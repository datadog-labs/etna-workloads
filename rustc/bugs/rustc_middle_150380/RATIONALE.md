# Adapted injection for add const kind match

Fix: https://github.com/rust-lang/rust/commit/517411f143f43689add7f5739a200fbdf8e2d03a

# Rationale
The fix's code (`destructure_const` in rustc_ty_utils/src/consts.rs) no longer exists in 1.99.1. Its equivalent is the ADT branch of `pretty_print_const_valtree` in `compiler/rustc_middle/src/ty/print/pretty.rs`, which prints the fields of an ADT valtree.

Hunk: `pretty_print_const_valtree`, `(ValTreeKind::Branch(_), ty::Adt(def, args))` arm.
Re-expresses fix hunk `@@ -39,25 +39,16 @@ fn destructure_const`. That hunk removed the loop
`Const::new_value(tcx, field_valtree.to_value().valtree, field_ty)`, which forced every field to be a concrete value. The re-injected code puts that loop back: each field is rebuilt with `field.to_value().valtree` and `new_value`. `to_value()` ICEs when a field is a non-value const, such as a param `N` or an unevaluated `<T as Trait>::ASSOC`.
