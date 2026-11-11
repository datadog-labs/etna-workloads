# Adapted injection for Report impl has stricter requirements even when RPITIT inference gets in the way

Fix: https://github.com/rust-lang/rust/commit/c29838843b0573a583f6457c176d9d49873e9eb5

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, fn `collect_return_position_impl_trait_in_trait_tys`.
Removed the loop (about 23 lines) that normalizes the impl method's own clauses and registers them as obligations in the hybrid param env, just before "Normalize the impl signature with fresh variables".
This re-expresses the fix hunk `@@ -529,6 +529,26 @@ pub(super) fn collect_return_position_impl_trait_in_trait_tys`, which added "Check that the where clauses of the impl are satisfied by the hybrid param env" and the `for (predicate, span) in impl_m_own_bounds` loop. On 1.99.1 the code uses `clauses_of` and `clause` names.
Without it, RPITIT inference reports spurious errors instead of "impl has stricter requirements".
