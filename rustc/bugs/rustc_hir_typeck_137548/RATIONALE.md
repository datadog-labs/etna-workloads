# Adapted injection for Better error message for unsized pointers

Fix: https://github.com/rust-lang/rust/commit/b2dee4226d55f94048be1f5800df73c1430f36b1

File: compiler/rustc_hir_typeck/src/inline_asm.rs (file moved from rustc_hir_analysis/src/check/intrinsicck.rs).
Function: InlineAsmCtxt::get_asm_ty and the error-reporting match in check_asm_operand_type.
Re-expresses all three fix hunks:
- `@@ -81,7 +82,13` : restored `ty::RawPtr(ty, _) if self.is_thin_ptr_ty(ty) => Ok(asm_ty_isize)` instead of the arm returning `Err(NotSizedPtr(ty))` for unsized pointers.
- `@@ -27,6 +27,7` : removed `NotSizedPtr(Ty)` enum variant.
- `@@ -187,6 +194,16` : removed the "cannot use value of unsized pointer type" error arm.
Unsized raw pointers now fall to the generic "cannot use value of type" error.
