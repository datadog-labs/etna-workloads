# Adapted injection for Properly deal with GATs when looking for method chains to point at

Fix: https://github.com/rust-lang/rust/commit/6035e8735a8384cd0d97e0081ecb5110c767d713

File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn probe_assoc_types_at_expr.

1. Generic args built from the trait's generics instead of the associated type's (re-expresses hunk `@@ -4219,30 +4220,25 @@`: fix replaced `GenericArgs::for_item(self.tcx, trait_def_id, ...)` with `for_item(self.tcx, proj.def_id, ...)`). I restored the trait-def-id version, so GAT params are missing from the args.
2. Removed the `&& !ty.is_ty_var()` check (same fix hunk: `&& !ty.is_ty_var()` added to the `if ocx.select_where_possible().is_empty()` condition).
