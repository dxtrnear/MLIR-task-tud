#include "Standalone/StencilPasses.h"
#include "Standalone/StandaloneOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Dialect/SCF/IR/SCF.h"

using namespace mlir;
using namespace mlir::standalone;

namespace {

struct ApplyOpLowering : public OpRewritePattern<ApplyOp> {
  using OpRewritePattern<ApplyOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(ApplyOp op,PatternRewriter &rewriter) const override {
    
    Location loc = op.getLoc();
    Value c0 = arith::ConstantIndexOp::create(rewriter, loc, 0);
    Value c1 = arith::ConstantIndexOp::create(rewriter, loc, 1);
    Value c2 = arith::ConstantIndexOp::create(rewriter, loc, 2);

    Value N = memref::DimOp::create(rewriter, loc, op.getOutput(), c0);
    Value M = memref::DimOp::create(rewriter, loc, op.getOutput(), c1);
    Value n = arith::SubIOp::create(rewriter, loc, N, c2);
    Value m = arith::SubIOp::create(rewriter, loc, M, c2);

    SmallVector<OpFoldResult> sizes = {n, m}; // dynamic: Values
    SmallVector<OpFoldResult> strides = {rewriter.getIndexAttr(1),rewriter.getIndexAttr(1)}; // static: 1, 1

    SmallVector<Value> windows; // %v0 ... %v4, in the offsets' order
    for (Attribute a : op.getOffsets()) {
      auto pair = llvm::cast<ArrayAttr>(a);
      int64_t di = llvm::cast<IntegerAttr>(pair[0]).getInt();
      int64_t dj = llvm::cast<IntegerAttr>(pair[1]).getInt();
      SmallVector<OpFoldResult> offs = {rewriter.getIndexAttr(1 + di),rewriter.getIndexAttr(1 + dj)};
      windows.push_back(memref::SubViewOp::create(rewriter, loc, op.getInput(),offs, sizes, strides));
    }
    SmallVector<OpFoldResult> one = {rewriter.getIndexAttr(1),rewriter.getIndexAttr(1)};
  Value out = memref::SubViewOp::create(rewriter, loc, op.getOutput(),one, sizes, strides);
  Value scale = arith::ConstantOp::create(rewriter, loc, op.getScaleAttr());

  // Create linalg.generic op
    SmallVector<AffineMap> maps(windows.size() + 1,rewriter.getMultiDimIdentityMap(2));
    SmallVector<utils::IteratorType> iters(2, utils::IteratorType::parallel);

    linalg::GenericOp::create(
        rewriter, loc,
        /*inputs=*/windows, /*outputs=*/ValueRange{out}, maps, iters,
        [&](OpBuilder &b, Location l, ValueRange args) {
          Value sum = args[0];
          for (size_t k = 1; k < windows.size(); ++k)
            sum = arith::AddFOp::create(b, l, sum, args[k]);
          Value r = arith::MulFOp::create(b, l, sum, scale);
          linalg::YieldOp::create(b, l, r);
        });

    rewriter.eraseOp(op);
    return success();
  }
};

struct StencilApplyToLinalgPass
    : public PassWrapper<StencilApplyToLinalgPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(StencilApplyToLinalgPass)

  StringRef getArgument() const final { return "stencil-apply-to-linalg"; }
  StringRef getDescription() const final {
    return "Lower stencil.apply to memref.subview + linalg.generic";
  }

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, linalg::LinalgDialect,memref::MemRefDialect>();
  }

  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<ApplyOpLowering>(&getContext());
    if (failed(applyPatternsGreedily(getOperation(), std::move(patterns))))
      signalPassFailure();
  }
};

struct SweepOpLowering : public OpRewritePattern<SweepOp> {
  using OpRewritePattern<SweepOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(SweepOp op,PatternRewriter &rewriter) const override {
    Location loc = op.getLoc();
    Value A = op.getGrid();

    Value c0 = arith::ConstantIndexOp::create(rewriter, loc, 0);
    Value c1 = arith::ConstantIndexOp::create(rewriter, loc, 1);
    Value N = memref::DimOp::create(rewriter, loc, A, c0);
    Value M = memref::DimOp::create(rewriter, loc, A, c1);
    Value ub0 = arith::SubIOp::create(rewriter, loc, N, c1);
    Value ub1 = arith::SubIOp::create(rewriter, loc, M, c1);
    Value divisor = arith::ConstantOp::create(rewriter, loc, op.getDivisorAttr());

    scf::ForOp::create(rewriter, loc, c1, ub0, c1, ValueRange{},
        [&](OpBuilder &b, Location l, Value i, ValueRange) {
          scf::ForOp::create(b, l, c1, ub1, c1, ValueRange{},
              [&](OpBuilder &b2, Location l2, Value j, ValueRange) {
                // for each offset [di, dj], in order:
                //   load A[i + di, j + dj], add it to the running sum.
                // Then divf by the divisor, store at A[i, j].
                Value sum;
                bool first = true;
                for (Attribute a : op.getOffsets()) {
                  auto pair = llvm::cast<ArrayAttr>(a);
                  int64_t di = llvm::cast<IntegerAttr>(pair[0]).getInt();
                  int64_t dj = llvm::cast<IntegerAttr>(pair[1]).getInt();
                  Value i_off = arith::AddIOp::create(b2, l2, i, arith::ConstantIndexOp::create(b2, l2, di));
                  Value j_off = arith::AddIOp::create(b2, l2, j, b2.create<arith::ConstantIndexOp>(l2, dj));
                  Value in = memref::LoadOp::create(b2, l2, A, ValueRange{i_off, j_off});
                  if (first) {
                    sum = in;
                    first = false;
                  } else {
                    sum = arith::AddFOp::create(b2, l2, sum, in);
                  }
                }
                Value div = arith::DivFOp::create(b2, l2, sum, divisor);
                memref::StoreOp::create(b2, l2, div, A, ValueRange{i, j});
                scf::YieldOp::create(b2, l2);
              });
          scf::YieldOp::create(b, l);
        });

    rewriter.eraseOp(op);
    return success();
  }
};

struct StencilSweepToScfPass
    : public PassWrapper<StencilSweepToScfPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(StencilSweepToScfPass)

  StringRef getArgument() const final { return "stencil-sweep-to-scf"; }
  StringRef getDescription() const final {
    return "Lower stencil.sweep to scf.for";
  }

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<arith::ArithDialect, scf::SCFDialect,memref::MemRefDialect>();
  }

  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<SweepOpLowering>(&getContext());
    if (failed(applyPatternsGreedily(getOperation(), std::move(patterns))))
      signalPassFailure();
  }
};

} // namespace
void mlir::standalone::registerStencilPasses() {
  PassRegistration<StencilApplyToLinalgPass>();
  PassRegistration<StencilSweepToScfPass>();
}
