# Adapted injection for Actually use placeholder regions for trait method late bound regions in collect_return_position_impl_trait_in_trait_tys

Fix: https://github.com/rust-lang/rust/commit/15dff274d07621283b38e4ca0008f7e6145c2519

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `collect_return_position_impl_trait_in_trait_tys`.

Both hunks swap which signature gets placeholder (liberated) regions and which gets inference vars, restoring the pre-fix behaviour.

1. Hunk `@@ -523,8 +523,9 @@`: the impl method sig went from `infcx.instantiate_binder_with_fresh_vars(...)` back to `tcx.liberate_late_bound_regions(impl_m.def_id, fn_sig(impl_m))`.
2. Hunk `@@ -536,10 +537,9 @@`: the trait method sig went from `tcx.liberate_late_bound_regions(impl_m.def_id, ...)` back to `infcx.instantiate_binder_with_fresh_vars(return_span, HigherRankedType, ...)`, before `.fold_with(&mut collector)`.

Trait late-bound regions are therefore no longer placeholders. They become inference variables that the impl's hidden type can constrain.
