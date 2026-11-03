; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @matmul_generic_interchanged(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20) {
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %14, 0
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, ptr %15, 1
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 %16, 2
  %25 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, i64 %17, 3, 0
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %25, i64 %19, 4, 0
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, i64 %18, 3, 1
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, i64 %20, 4, 1
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %7, 0
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, ptr %8, 1
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %9, 2
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %10, 3, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 %12, 4, 0
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 %11, 3, 1
  %35 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, i64 %13, 4, 1
  %36 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %0, 0
  %37 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %36, ptr %1, 1
  %38 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %37, i64 %2, 2
  %39 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %38, i64 %3, 3, 0
  %40 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %39, i64 %5, 4, 0
  %41 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %40, i64 %4, 3, 1
  %42 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %41, i64 %6, 4, 1
  %43 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, 3
  %44 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %43, ptr %44, align 4
  %45 = getelementptr [2 x i64], ptr %44, i32 0, i64 0
  %46 = load i64, ptr %45, align 4
  %47 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, 3
  %48 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %47, ptr %48, align 4
  %49 = getelementptr [2 x i64], ptr %48, i32 0, i64 1
  %50 = load i64, ptr %49, align 4
  %51 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %35, 3
  %52 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %51, ptr %52, align 4
  %53 = getelementptr [2 x i64], ptr %52, i32 0, i64 1
  %54 = load i64, ptr %53, align 4
  br label %55

55:                                               ; preds = %95, %21
  %56 = phi i64 [ %96, %95 ], [ 0, %21 ]
  %57 = icmp slt i64 %56, %46
  br i1 %57, label %58, label %97

58:                                               ; preds = %55
  br label %59

59:                                               ; preds = %93, %58
  %60 = phi i64 [ %94, %93 ], [ 0, %58 ]
  %61 = icmp slt i64 %60, %50
  br i1 %61, label %62, label %95

62:                                               ; preds = %59
  br label %63

63:                                               ; preds = %66, %62
  %64 = phi i64 [ %92, %66 ], [ 0, %62 ]
  %65 = icmp slt i64 %64, %54
  br i1 %65, label %66, label %93

66:                                               ; preds = %63
  %67 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, 1
  %68 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, 4, 0
  %69 = mul nsw i64 %56, %68
  %70 = add nsw i64 %69, %60
  %71 = getelementptr inbounds double, ptr %67, i64 %70
  %72 = load double, ptr %71, align 8
  %73 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %35, 1
  %74 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %35, 4, 0
  %75 = mul nsw i64 %60, %74
  %76 = add nsw i64 %75, %64
  %77 = getelementptr inbounds double, ptr %73, i64 %76
  %78 = load double, ptr %77, align 8
  %79 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, 1
  %80 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, 4, 0
  %81 = mul nsw i64 %56, %80
  %82 = add nsw i64 %81, %64
  %83 = getelementptr inbounds double, ptr %79, i64 %82
  %84 = load double, ptr %83, align 8
  %85 = fmul double %72, %78
  %86 = fadd double %84, %85
  %87 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, 1
  %88 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, 4, 0
  %89 = mul nsw i64 %56, %88
  %90 = add nsw i64 %89, %64
  %91 = getelementptr inbounds double, ptr %87, i64 %90
  store double %86, ptr %91, align 8
  %92 = add i64 %64, 1
  br label %63

93:                                               ; preds = %63
  %94 = add i64 %60, 1
  br label %59

95:                                               ; preds = %59
  %96 = add i64 %56, 1
  br label %55

97:                                               ; preds = %55
  ret void
}

define void @_mlir_ciface_matmul_generic_interchanged(ptr %0, ptr %1, ptr %2) {
  %4 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %0, align 8
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 0
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 1
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 2
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 0
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 1
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 0
  %11 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 1
  %12 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %1, align 8
  %13 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 0
  %14 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 2
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 0
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 1
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 0
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 1
  %20 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %2, align 8
  %21 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, 0
  %22 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, 1
  %23 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, 2
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, 3, 0
  %25 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, 3, 1
  %26 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, 4, 0
  %27 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, 4, 1
  call void @matmul_generic_interchanged(ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11, ptr %13, ptr %14, i64 %15, i64 %16, i64 %17, i64 %18, i64 %19, ptr %21, ptr %22, i64 %23, i64 %24, i64 %25, i64 %26, i64 %27)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
