# Adapted injection for Ignore Self in bounds check for associated types with Self:Sized

Fix: https://github.com/rust-lang/rust/commit/309e371f7b062865199c38cfebe00173698c0aad

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, fn `bounds_reference_self`.
Removed `.filter(|item| !tcx.generics_require_sized_self(item.def_id))` (the "Ignore GATs with `Self: Sized`" filter).
Re-expresses the fix hunk `@@ -187,7 +187,10 @@ fn predicates_reference_self` which added
`// Ignore GATs with Self: Sized` / `.filter(|item| !tcx.generics_require_sized_self(item.def_id))`.
Now assoc types with `where Self: Sized` have their bounds mentioning Self wrongly flagged as dyn-compat violations.
