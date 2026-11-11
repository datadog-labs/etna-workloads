# Adapted injection for Fix sized constraint for unsafe binder

Fix: https://github.com/rust-lang/rust/commit/b67b6c05032e98a5984ebb39f581125e7d0b48b9

compiler/rustc_ty_utils/src/ty.rs, `sizedness_constraint_for_ty`: replaced the `ty::UnsafeBinder(inner_ty) => sizedness_constraint_for_ty(.., inner_ty.skip_binder()).map(|_| ty)` arm with `ty::UnsafeBinder(_) => todo!()`.
This re-expresses the fix hunks `@@ -37,8 +37,6 @@` (removed `UnsafeBinder(_) => todo!(),`) and `@@ -52,9 +50,14 @@` (added the UnsafeBinder arm). Parent behaviour: ICE on a struct with an unsafe binder field.
