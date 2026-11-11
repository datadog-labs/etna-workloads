# Adapted injection for Instantiate higher-ranked binder with erased when checking IntoIterator predicate query instability

Fix: https://github.com/rust-lang/rust/commit/d18d94d8a0416f9013ad6e59ffae3d9e57382add

# Rationale
File: compiler/rustc_lint/src/internal.rs, fn `has_unstable_into_iter_predicate`.
Re-expresses fix hunk `@@ -129,18 +129,23 @@ fn has_unstable_into_iter_predicate`: the fix added
`cx.tcx.instantiate_bound_regions_with_erased(trait_pred).trait_ref.args`; the buggy parent used
`skip_binder()` and passed trait_ref.args (with escaping bound vars) to `Instance::try_resolve`.
I restored that: `trait_clause.skip_norm_wip().skip_binder().trait_ref.args`.
