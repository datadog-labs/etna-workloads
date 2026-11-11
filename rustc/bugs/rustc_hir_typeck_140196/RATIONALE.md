# Adapted injection for fix for issue 135412

Fix: https://github.com/rust-lang/rust/commit/c9deaf6aaa8e389e11e39abb9aca77e6340d176e

# Rationale
compiler/rustc_hir_typeck/src/cast.rs, `CastCheck::report_cast_error` (non-primitive cast, `From` suggestion).
Fix hunk `@@ -501,12 +501,25 @@` added `if let ty::Adt(def, args) = self.cast_ty.kind()` using `tcx.value_path_str_with_args(def.did(), args)` so the path reads `Option::<_>::from`. In 1.99.1 that logic is the `to_ty` binding; I reverted it to `self.cast_ty.to_string()`, restoring the old `Option<_>::from(..)` (invalid syntax) suggestion.
