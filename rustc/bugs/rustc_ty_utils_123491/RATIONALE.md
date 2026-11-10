# Adapted injection for Fail candidate assembly for erroneous types

Fix: https://github.com/rust-lang/rust/commit/c30e15adedba70d99a09146707814d14a93364a1

# Hunk: compiler/rustc_ty_utils/src/ty.rs, `adt_sizedness_constraint`
Re-adds the pre-fix behaviour (and the `TypeVisitableExt` import for `references_error`):
after computing `constraint_ty`, `if constraint_ty.references_error() { return None; }`.
This reverses fix hunk `@@ -91,8 +91,8 @@ fn adt_sized_constraint` which replaced
`if constraint_ty.references_error() { return None; }` with
`if let Err(guar) = constraint_ty.error_reported() { return Some(Ty::new_error(..)) }`.
So structs whose unsized tail has an error type are treated as Sized again, leading to the ICE in #123154.
The other fix hunks (candidate_assembly Sized check, error-reporting taint) are not present in 1.99.1 in the same form and were not touched.
