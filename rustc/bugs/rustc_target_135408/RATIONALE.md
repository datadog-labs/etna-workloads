# Adapted injection for x86-sse2 ABI: use SSE registers for floats and SIMD

Fix: https://github.com/rust-lang/rust/commit/803feb5dc679556ba2d93fe616d1883d7ebc7775

# Rationale
Only `compiler/rustc_target/src/callconv/x86.rs`, `compute_rust_abi_info`, changed.
Re-expresses fix hunk `@@ -236,8 +236,16 @@ ... if has_float {` in x86.rs: removes the
`if cx.target_spec().rustc_abi == Some(RustcAbi::X86Sse2) && ret is scalar && size.bits() <= 128 { cast_to(Reg vector) }`
branch, so float scalars on x86-sse2 go back to integer registers (or indirect), as before the fix. Also dropped the now-unused `RustcAbi` import (fix hunk #1 of x86.rs).
The mod.rs hunks (can_pass_simd_directly) were already reverted upstream in 1.99.1 (SIMD always indirect), so nothing to re-inject there.
