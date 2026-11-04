add_mlir_dialect_library(MLIRStandalone
        StandaloneDialect.cpp
        StandaloneOps.cpp
        StencilLowering.cpp

        ADDITIONAL_HEADER_DIRS
        ${PROJECT_SOURCE_DIR}/include/Standalone

        DEPENDS
        MLIRStandaloneOpsIncGen

	LINK_LIBS PUBLIC
	MLIRIR
        MLIRInferTypeOpInterface
        MLIRArithDialect
        MLIRLinalgDialect
        MLIRMemRefDialect
        MLIRPass
        MLIRTransformUtils
        MLIRSCFDialect


	)
