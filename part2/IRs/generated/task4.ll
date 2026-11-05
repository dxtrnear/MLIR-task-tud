; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @kernel_jacobi_2d(i64 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7, ptr %8, ptr %9, i64 %10, i64 %11, i64 %12, i64 %13, i64 %14) {
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %8, 0
  %17 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, ptr %9, 1
  %18 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %17, i64 %10, 2
  %19 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %18, i64 %11, 3, 0
  %20 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %19, i64 %13, 4, 0
  %21 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, i64 %12, 3, 1
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %21, i64 %14, 4, 1
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %1, 0
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, ptr %2, 1
  %25 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, i64 %3, 2
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %25, i64 %4, 3, 0
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, i64 %6, 4, 0
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, i64 %5, 3, 1
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, i64 %7, 4, 1
  br label %30

30:                                               ; preds = %417, %15
  %31 = phi i64 [ %418, %417 ], [ 0, %15 ]
  %32 = icmp slt i64 %31, %0
  br i1 %32, label %33, label %419

33:                                               ; preds = %30
  %34 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %35 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %34, ptr %35, align 4
  %36 = getelementptr [2 x i64], ptr %35, i32 0, i64 0
  %37 = load i64, ptr %36, align 4
  %38 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3
  %39 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %38, ptr %39, align 4
  %40 = getelementptr [2 x i64], ptr %39, i32 0, i64 1
  %41 = load i64, ptr %40, align 4
  %42 = sub i64 %37, 2
  %43 = sub i64 %41, 2
  %44 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %45 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %46 = insertvalue { ptr, ptr, i64 } poison, ptr %44, 0
  %47 = insertvalue { ptr, ptr, i64 } %46, ptr %45, 1
  %48 = insertvalue { ptr, ptr, i64 } %47, i64 0, 2
  %49 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %50 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %51 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %52 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %53 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %54 = add i64 %52, 1
  %55 = extractvalue { ptr, ptr, i64 } %48, 0
  %56 = extractvalue { ptr, ptr, i64 } %48, 1
  %57 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %55, 0
  %58 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %57, ptr %56, 1
  %59 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %58, i64 %54, 2
  %60 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %59, i64 %42, 3, 0
  %61 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %60, i64 %52, 4, 0
  %62 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %61, i64 %43, 3, 1
  %63 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %62, i64 1, 4, 1
  %64 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %65 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %66 = insertvalue { ptr, ptr, i64 } poison, ptr %64, 0
  %67 = insertvalue { ptr, ptr, i64 } %66, ptr %65, 1
  %68 = insertvalue { ptr, ptr, i64 } %67, i64 0, 2
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %70 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %71 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %72 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %73 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %74 = extractvalue { ptr, ptr, i64 } %68, 0
  %75 = extractvalue { ptr, ptr, i64 } %68, 1
  %76 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %74, 0
  %77 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %76, ptr %75, 1
  %78 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %77, i64 %72, 2
  %79 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %78, i64 %42, 3, 0
  %80 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %79, i64 %72, 4, 0
  %81 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %80, i64 %43, 3, 1
  %82 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %81, i64 1, 4, 1
  %83 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %84 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %85 = insertvalue { ptr, ptr, i64 } poison, ptr %83, 0
  %86 = insertvalue { ptr, ptr, i64 } %85, ptr %84, 1
  %87 = insertvalue { ptr, ptr, i64 } %86, i64 0, 2
  %88 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %89 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %90 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %91 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %92 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %93 = add i64 %91, 2
  %94 = extractvalue { ptr, ptr, i64 } %87, 0
  %95 = extractvalue { ptr, ptr, i64 } %87, 1
  %96 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %94, 0
  %97 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %96, ptr %95, 1
  %98 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %97, i64 %93, 2
  %99 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %98, i64 %42, 3, 0
  %100 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %99, i64 %91, 4, 0
  %101 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %100, i64 %43, 3, 1
  %102 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %101, i64 1, 4, 1
  %103 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %104 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %105 = insertvalue { ptr, ptr, i64 } poison, ptr %103, 0
  %106 = insertvalue { ptr, ptr, i64 } %105, ptr %104, 1
  %107 = insertvalue { ptr, ptr, i64 } %106, i64 0, 2
  %108 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %109 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %110 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %111 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %112 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %113 = mul nsw i64 %111, 2
  %114 = add i64 %113, 1
  %115 = extractvalue { ptr, ptr, i64 } %107, 0
  %116 = extractvalue { ptr, ptr, i64 } %107, 1
  %117 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %115, 0
  %118 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %117, ptr %116, 1
  %119 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %118, i64 %114, 2
  %120 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %119, i64 %42, 3, 0
  %121 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %120, i64 %111, 4, 0
  %122 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %121, i64 %43, 3, 1
  %123 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %122, i64 1, 4, 1
  %124 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %125 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %126 = insertvalue { ptr, ptr, i64 } poison, ptr %124, 0
  %127 = insertvalue { ptr, ptr, i64 } %126, ptr %125, 1
  %128 = insertvalue { ptr, ptr, i64 } %127, i64 0, 2
  %129 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %130 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %131 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %132 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %133 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %134 = extractvalue { ptr, ptr, i64 } %128, 0
  %135 = extractvalue { ptr, ptr, i64 } %128, 1
  %136 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %134, 0
  %137 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %136, ptr %135, 1
  %138 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %137, i64 1, 2
  %139 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %138, i64 %42, 3, 0
  %140 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %139, i64 %132, 4, 0
  %141 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %140, i64 %43, 3, 1
  %142 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %141, i64 1, 4, 1
  %143 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %144 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %145 = insertvalue { ptr, ptr, i64 } poison, ptr %143, 0
  %146 = insertvalue { ptr, ptr, i64 } %145, ptr %144, 1
  %147 = insertvalue { ptr, ptr, i64 } %146, i64 0, 2
  %148 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %149 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %150 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %151 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %152 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %153 = add i64 %151, 1
  %154 = extractvalue { ptr, ptr, i64 } %147, 0
  %155 = extractvalue { ptr, ptr, i64 } %147, 1
  %156 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %154, 0
  %157 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %156, ptr %155, 1
  %158 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %157, i64 %153, 2
  %159 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %158, i64 %42, 3, 0
  %160 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %159, i64 %151, 4, 0
  %161 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %160, i64 %43, 3, 1
  %162 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %161, i64 1, 4, 1
  br label %163

163:                                              ; preds = %223, %33
  %164 = phi i64 [ %224, %223 ], [ 0, %33 ]
  %165 = icmp slt i64 %164, %42
  br i1 %165, label %166, label %225

166:                                              ; preds = %163
  br label %167

167:                                              ; preds = %170, %166
  %168 = phi i64 [ %222, %170 ], [ 0, %166 ]
  %169 = icmp slt i64 %168, %43
  br i1 %169, label %170, label %223

170:                                              ; preds = %167
  %171 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %63, 1
  %172 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %63, 2
  %173 = getelementptr double, ptr %171, i64 %172
  %174 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %63, 4, 0
  %175 = mul nsw i64 %164, %174
  %176 = add nsw i64 %175, %168
  %177 = getelementptr inbounds double, ptr %173, i64 %176
  %178 = load double, ptr %177, align 8
  %179 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %82, 1
  %180 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %82, 2
  %181 = getelementptr double, ptr %179, i64 %180
  %182 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %82, 4, 0
  %183 = mul nsw i64 %164, %182
  %184 = add nsw i64 %183, %168
  %185 = getelementptr inbounds double, ptr %181, i64 %184
  %186 = load double, ptr %185, align 8
  %187 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %102, 1
  %188 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %102, 2
  %189 = getelementptr double, ptr %187, i64 %188
  %190 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %102, 4, 0
  %191 = mul nsw i64 %164, %190
  %192 = add nsw i64 %191, %168
  %193 = getelementptr inbounds double, ptr %189, i64 %192
  %194 = load double, ptr %193, align 8
  %195 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %123, 1
  %196 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %123, 2
  %197 = getelementptr double, ptr %195, i64 %196
  %198 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %123, 4, 0
  %199 = mul nsw i64 %164, %198
  %200 = add nsw i64 %199, %168
  %201 = getelementptr inbounds double, ptr %197, i64 %200
  %202 = load double, ptr %201, align 8
  %203 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %142, 1
  %204 = getelementptr double, ptr %203, i64 1
  %205 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %142, 4, 0
  %206 = mul nsw i64 %164, %205
  %207 = add nsw i64 %206, %168
  %208 = getelementptr inbounds double, ptr %204, i64 %207
  %209 = load double, ptr %208, align 8
  %210 = fadd double %178, %186
  %211 = fadd double %210, %194
  %212 = fadd double %211, %202
  %213 = fadd double %212, %209
  %214 = fmul double %213, 2.000000e-01
  %215 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %162, 1
  %216 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %162, 2
  %217 = getelementptr double, ptr %215, i64 %216
  %218 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %162, 4, 0
  %219 = mul nsw i64 %164, %218
  %220 = add nsw i64 %219, %168
  %221 = getelementptr inbounds double, ptr %217, i64 %220
  store double %214, ptr %221, align 8
  %222 = add i64 %168, 1
  br label %167

223:                                              ; preds = %167
  %224 = add i64 %164, 1
  br label %163

225:                                              ; preds = %163
  %226 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %227 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %226, ptr %227, align 4
  %228 = getelementptr [2 x i64], ptr %227, i32 0, i64 0
  %229 = load i64, ptr %228, align 4
  %230 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3
  %231 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %230, ptr %231, align 4
  %232 = getelementptr [2 x i64], ptr %231, i32 0, i64 1
  %233 = load i64, ptr %232, align 4
  %234 = sub i64 %229, 2
  %235 = sub i64 %233, 2
  %236 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %237 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %238 = insertvalue { ptr, ptr, i64 } poison, ptr %236, 0
  %239 = insertvalue { ptr, ptr, i64 } %238, ptr %237, 1
  %240 = insertvalue { ptr, ptr, i64 } %239, i64 0, 2
  %241 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %242 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %243 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %244 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %245 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %246 = add i64 %244, 1
  %247 = extractvalue { ptr, ptr, i64 } %240, 0
  %248 = extractvalue { ptr, ptr, i64 } %240, 1
  %249 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %247, 0
  %250 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %249, ptr %248, 1
  %251 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %250, i64 %246, 2
  %252 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %251, i64 %234, 3, 0
  %253 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %252, i64 %244, 4, 0
  %254 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %253, i64 %235, 3, 1
  %255 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %254, i64 1, 4, 1
  %256 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %257 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %258 = insertvalue { ptr, ptr, i64 } poison, ptr %256, 0
  %259 = insertvalue { ptr, ptr, i64 } %258, ptr %257, 1
  %260 = insertvalue { ptr, ptr, i64 } %259, i64 0, 2
  %261 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %262 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %263 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %264 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %265 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %266 = extractvalue { ptr, ptr, i64 } %260, 0
  %267 = extractvalue { ptr, ptr, i64 } %260, 1
  %268 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %266, 0
  %269 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %268, ptr %267, 1
  %270 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %269, i64 %264, 2
  %271 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %270, i64 %234, 3, 0
  %272 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %271, i64 %264, 4, 0
  %273 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %272, i64 %235, 3, 1
  %274 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %273, i64 1, 4, 1
  %275 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %276 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %277 = insertvalue { ptr, ptr, i64 } poison, ptr %275, 0
  %278 = insertvalue { ptr, ptr, i64 } %277, ptr %276, 1
  %279 = insertvalue { ptr, ptr, i64 } %278, i64 0, 2
  %280 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %281 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %282 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %283 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %284 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %285 = add i64 %283, 2
  %286 = extractvalue { ptr, ptr, i64 } %279, 0
  %287 = extractvalue { ptr, ptr, i64 } %279, 1
  %288 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %286, 0
  %289 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %288, ptr %287, 1
  %290 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %289, i64 %285, 2
  %291 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %290, i64 %234, 3, 0
  %292 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %291, i64 %283, 4, 0
  %293 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %292, i64 %235, 3, 1
  %294 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %293, i64 1, 4, 1
  %295 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %296 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %297 = insertvalue { ptr, ptr, i64 } poison, ptr %295, 0
  %298 = insertvalue { ptr, ptr, i64 } %297, ptr %296, 1
  %299 = insertvalue { ptr, ptr, i64 } %298, i64 0, 2
  %300 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %301 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %302 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %303 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %304 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %305 = mul nsw i64 %303, 2
  %306 = add i64 %305, 1
  %307 = extractvalue { ptr, ptr, i64 } %299, 0
  %308 = extractvalue { ptr, ptr, i64 } %299, 1
  %309 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %307, 0
  %310 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %309, ptr %308, 1
  %311 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %310, i64 %306, 2
  %312 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %311, i64 %234, 3, 0
  %313 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %312, i64 %303, 4, 0
  %314 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %313, i64 %235, 3, 1
  %315 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %314, i64 1, 4, 1
  %316 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 0
  %317 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 1
  %318 = insertvalue { ptr, ptr, i64 } poison, ptr %316, 0
  %319 = insertvalue { ptr, ptr, i64 } %318, ptr %317, 1
  %320 = insertvalue { ptr, ptr, i64 } %319, i64 0, 2
  %321 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 2
  %322 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 0
  %323 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 3, 1
  %324 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 0
  %325 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, 4, 1
  %326 = extractvalue { ptr, ptr, i64 } %320, 0
  %327 = extractvalue { ptr, ptr, i64 } %320, 1
  %328 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %326, 0
  %329 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %328, ptr %327, 1
  %330 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %329, i64 1, 2
  %331 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %330, i64 %234, 3, 0
  %332 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %331, i64 %324, 4, 0
  %333 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %332, i64 %235, 3, 1
  %334 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %333, i64 1, 4, 1
  %335 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 0
  %336 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 1
  %337 = insertvalue { ptr, ptr, i64 } poison, ptr %335, 0
  %338 = insertvalue { ptr, ptr, i64 } %337, ptr %336, 1
  %339 = insertvalue { ptr, ptr, i64 } %338, i64 0, 2
  %340 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 2
  %341 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 0
  %342 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 3, 1
  %343 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 0
  %344 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, 4, 1
  %345 = add i64 %343, 1
  %346 = extractvalue { ptr, ptr, i64 } %339, 0
  %347 = extractvalue { ptr, ptr, i64 } %339, 1
  %348 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %346, 0
  %349 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %348, ptr %347, 1
  %350 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %349, i64 %345, 2
  %351 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %350, i64 %234, 3, 0
  %352 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %351, i64 %343, 4, 0
  %353 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %352, i64 %235, 3, 1
  %354 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %353, i64 1, 4, 1
  br label %355

355:                                              ; preds = %415, %225
  %356 = phi i64 [ %416, %415 ], [ 0, %225 ]
  %357 = icmp slt i64 %356, %234
  br i1 %357, label %358, label %417

358:                                              ; preds = %355
  br label %359

359:                                              ; preds = %362, %358
  %360 = phi i64 [ %414, %362 ], [ 0, %358 ]
  %361 = icmp slt i64 %360, %235
  br i1 %361, label %362, label %415

362:                                              ; preds = %359
  %363 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %255, 1
  %364 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %255, 2
  %365 = getelementptr double, ptr %363, i64 %364
  %366 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %255, 4, 0
  %367 = mul nsw i64 %356, %366
  %368 = add nsw i64 %367, %360
  %369 = getelementptr inbounds double, ptr %365, i64 %368
  %370 = load double, ptr %369, align 8
  %371 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %274, 1
  %372 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %274, 2
  %373 = getelementptr double, ptr %371, i64 %372
  %374 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %274, 4, 0
  %375 = mul nsw i64 %356, %374
  %376 = add nsw i64 %375, %360
  %377 = getelementptr inbounds double, ptr %373, i64 %376
  %378 = load double, ptr %377, align 8
  %379 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %294, 1
  %380 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %294, 2
  %381 = getelementptr double, ptr %379, i64 %380
  %382 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %294, 4, 0
  %383 = mul nsw i64 %356, %382
  %384 = add nsw i64 %383, %360
  %385 = getelementptr inbounds double, ptr %381, i64 %384
  %386 = load double, ptr %385, align 8
  %387 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %315, 1
  %388 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %315, 2
  %389 = getelementptr double, ptr %387, i64 %388
  %390 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %315, 4, 0
  %391 = mul nsw i64 %356, %390
  %392 = add nsw i64 %391, %360
  %393 = getelementptr inbounds double, ptr %389, i64 %392
  %394 = load double, ptr %393, align 8
  %395 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %334, 1
  %396 = getelementptr double, ptr %395, i64 1
  %397 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %334, 4, 0
  %398 = mul nsw i64 %356, %397
  %399 = add nsw i64 %398, %360
  %400 = getelementptr inbounds double, ptr %396, i64 %399
  %401 = load double, ptr %400, align 8
  %402 = fadd double %370, %378
  %403 = fadd double %402, %386
  %404 = fadd double %403, %394
  %405 = fadd double %404, %401
  %406 = fmul double %405, 2.000000e-01
  %407 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %354, 1
  %408 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %354, 2
  %409 = getelementptr double, ptr %407, i64 %408
  %410 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %354, 4, 0
  %411 = mul nsw i64 %356, %410
  %412 = add nsw i64 %411, %360
  %413 = getelementptr inbounds double, ptr %409, i64 %412
  store double %406, ptr %413, align 8
  %414 = add i64 %360, 1
  br label %359

415:                                              ; preds = %359
  %416 = add i64 %356, 1
  br label %355

417:                                              ; preds = %355
  %418 = add i64 %31, 1
  br label %30

419:                                              ; preds = %30
  ret void
}

define void @_mlir_ciface_kernel_jacobi_2d(i64 %0, ptr %1, ptr %2) {
  %4 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %1, align 8
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 0
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 1
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 2
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 0
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 3, 1
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 0
  %11 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, 4, 1
  %12 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %2, align 8
  %13 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 0
  %14 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 1
  %15 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 2
  %16 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 0
  %17 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 3, 1
  %18 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 0
  %19 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, 4, 1
  call void @kernel_jacobi_2d(i64 %0, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11, ptr %13, ptr %14, i64 %15, i64 %16, i64 %17, i64 %18, i64 %19)
  ret void
}

define void @kernel_seidel_2d(i64 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) {
  %9 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %1, 0
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %9, ptr %2, 1
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, i64 %3, 2
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 %4, 3, 0
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 %6, 4, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 %5, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 %7, 4, 1
  br label %16

16:                                               ; preds = %121, %8
  %17 = phi i64 [ %122, %121 ], [ 0, %8 ]
  %18 = icmp slt i64 %17, %0
  br i1 %18, label %19, label %123

19:                                               ; preds = %16
  %20 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3
  %21 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %20, ptr %21, align 4
  %22 = getelementptr [2 x i64], ptr %21, i32 0, i64 0
  %23 = load i64, ptr %22, align 4
  %24 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 3
  %25 = alloca [2 x i64], i64 1, align 8
  store [2 x i64] %24, ptr %25, align 4
  %26 = getelementptr [2 x i64], ptr %25, i32 0, i64 1
  %27 = load i64, ptr %26, align 4
  %28 = sub i64 %23, 1
  %29 = sub i64 %27, 1
  br label %30

30:                                               ; preds = %119, %19
  %31 = phi i64 [ %120, %119 ], [ 1, %19 ]
  %32 = icmp slt i64 %31, %28
  br i1 %32, label %33, label %121

33:                                               ; preds = %30
  br label %34

34:                                               ; preds = %37, %33
  %35 = phi i64 [ %118, %37 ], [ 1, %33 ]
  %36 = icmp slt i64 %35, %29
  br i1 %36, label %37, label %119

37:                                               ; preds = %34
  %38 = add i64 %31, -1
  %39 = add i64 %35, -1
  %40 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %41 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %42 = mul nsw i64 %38, %41
  %43 = add nsw i64 %42, %39
  %44 = getelementptr inbounds double, ptr %40, i64 %43
  %45 = load double, ptr %44, align 8
  %46 = add i64 %31, -1
  %47 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %48 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %49 = mul nsw i64 %46, %48
  %50 = add nsw i64 %49, %35
  %51 = getelementptr inbounds double, ptr %47, i64 %50
  %52 = load double, ptr %51, align 8
  %53 = fadd double %45, %52
  %54 = add i64 %31, -1
  %55 = add i64 %35, 1
  %56 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %57 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %58 = mul nsw i64 %54, %57
  %59 = add nsw i64 %58, %55
  %60 = getelementptr inbounds double, ptr %56, i64 %59
  %61 = load double, ptr %60, align 8
  %62 = fadd double %53, %61
  %63 = add i64 %35, -1
  %64 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %65 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %66 = mul nsw i64 %31, %65
  %67 = add nsw i64 %66, %63
  %68 = getelementptr inbounds double, ptr %64, i64 %67
  %69 = load double, ptr %68, align 8
  %70 = fadd double %62, %69
  %71 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %72 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %73 = mul nsw i64 %31, %72
  %74 = add nsw i64 %73, %35
  %75 = getelementptr inbounds double, ptr %71, i64 %74
  %76 = load double, ptr %75, align 8
  %77 = fadd double %70, %76
  %78 = add i64 %35, 1
  %79 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %80 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %81 = mul nsw i64 %31, %80
  %82 = add nsw i64 %81, %78
  %83 = getelementptr inbounds double, ptr %79, i64 %82
  %84 = load double, ptr %83, align 8
  %85 = fadd double %77, %84
  %86 = add i64 %31, 1
  %87 = add i64 %35, -1
  %88 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %89 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %90 = mul nsw i64 %86, %89
  %91 = add nsw i64 %90, %87
  %92 = getelementptr inbounds double, ptr %88, i64 %91
  %93 = load double, ptr %92, align 8
  %94 = fadd double %85, %93
  %95 = add i64 %31, 1
  %96 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %97 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %98 = mul nsw i64 %95, %97
  %99 = add nsw i64 %98, %35
  %100 = getelementptr inbounds double, ptr %96, i64 %99
  %101 = load double, ptr %100, align 8
  %102 = fadd double %94, %101
  %103 = add i64 %31, 1
  %104 = add i64 %35, 1
  %105 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %106 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %107 = mul nsw i64 %103, %106
  %108 = add nsw i64 %107, %104
  %109 = getelementptr inbounds double, ptr %105, i64 %108
  %110 = load double, ptr %109, align 8
  %111 = fadd double %102, %110
  %112 = fdiv double %111, 9.000000e+00
  %113 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 1
  %114 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, 4, 0
  %115 = mul nsw i64 %31, %114
  %116 = add nsw i64 %115, %35
  %117 = getelementptr inbounds double, ptr %113, i64 %116
  store double %112, ptr %117, align 8
  %118 = add i64 %35, 1
  br label %34

119:                                              ; preds = %34
  %120 = add i64 %31, 1
  br label %30

121:                                              ; preds = %30
  %122 = add i64 %17, 1
  br label %16

123:                                              ; preds = %16
  ret void
}

define void @_mlir_ciface_kernel_seidel_2d(i64 %0, ptr %1) {
  %3 = load { ptr, ptr, i64, [2 x i64], [2 x i64] }, ptr %1, align 8
  %4 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 0
  %5 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 1
  %6 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 2
  %7 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 0
  %8 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 3, 1
  %9 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 0
  %10 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, 4, 1
  call void @kernel_seidel_2d(i64 %0, ptr %4, ptr %5, i64 %6, i64 %7, i64 %8, i64 %9, i64 %10)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
