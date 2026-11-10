# Adapted injection for Move refinement check out of compare_impl_item

Fix: https://github.com/rust-lang/rust/commit/1e655ef21385eee0a3c224523eac316c7c20e8ed

# Rationale
Bug: the RPITIT refinement check ran inside the `compare_impl_item` query, causing query cycles (refine-cycle.rs).

1. compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, `compare_impl_method`: re-added the call to
   `refine::check_refining_return_position_impl_trait_in_trait(tcx, impl_m, trait_m, impl_trait_ref)` after
   `compare_method_clause_entailment`. Reverses fix hunk `@@ -70,12 +70,6 @@ fn compare_impl_method` (removed that call).
2. compiler/rustc_hir_analysis/src/check/check.rs, `check_impl_items_against_trait`: removed the `if res.is_ok() { match kind { Fn => refine::check_refining... } }` block and the `res` binding (now `let _ =`). Reverses fix hunk `@@ -1045,7 +1045,24 @@ fn check_impl_items_against_trait`.
(Visibility changes in the fix were left as is; they are harmless.)
