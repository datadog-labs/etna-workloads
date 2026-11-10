# Adapted injection for Use a query rather than recomputing the tail repeatedly

Fix: https://github.com/rust-lang/rust/commit/830aeb610289924b5910f409f6751fcf4e497f1e

# Rationale
Only hunk changed: compiler/rustc_trait_selection/src/traits/project.rs, `confirm_impl_candidate`.
Re-expresses fix hunk `@@ -2007,21 +2007,7 @@ fn confirm_impl_candidate`: the fix replaced the inline
`selcx.tcx().struct_tail_raw(type_of(impl).instantiate(..), |ty| normalize_with_depth_to(..), || {})` +
`tail.is_guaranteed_unsized_raw()` with `tcx.impl_self_is_guaranteed_unsized(impl_def_id)`.
I restored the inline recomputation (adapted to the 1.99.1 `struct_tail_raw` signature with a cause,
`skip_norm_wip`, and the `inherent::Ty::is_guaranteed_unsized_raw` trait method) instead of using the query.
The query (and its other users in check.rs / next solver) is left in place, so the cycle error from the query is gone
and the old overflow behaviour returns (impl-wf-cycle-4 fails).
