# Adapted injection for rename min/maxnum intrinsics to min/maximum_number and fix their LLVM lowering

Fix: https://github.com/rust-lang/rust/commit/c7220f423b335974509b603b8e1dcbb08a92184d

# Rationale
Only one hunk: `compiler/rustc_codegen_llvm/src/intrinsic.rs`, `codegen_intrinsic_call`, arm for `sym::minimum_number_nsz_*` / `maximum_number_nsz_*`.

Re-expresses fix hunk `@@ -195,6 +185,32 @@ impl ... IntrinsicCallBuilderMethods` of that file, which added the arm lowering to `llvm.minimumnum`/`llvm.maximumnum` (+ `LLVMRustSetNoSignedZeros`). Before the fix, min/maxnum were lowered to `llvm.minnum`/`llvm.maxnum` (the removed `sym::minnumf32 => ("llvm.minnum", ...)` lines), which mishandle signaling NaNs. I made the arm emit `llvm.minnum`/`llvm.maxnum` and dropped the nsz call.
