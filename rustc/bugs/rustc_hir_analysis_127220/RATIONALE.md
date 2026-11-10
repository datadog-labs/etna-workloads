# Adapted injection for Rewrite dropck

Fix: https://github.com/rust-lang/rust/commit/6a0000827671ab12837a5a3a692d5dd9c31def69

# Rationale
File: compiler/rustc_hir_analysis/src/check/always_applicable.rs, fn `ensure_impl_predicates_are_implied_by_item_defn` (the 1.99.1 successor of dropck.rs `ensure_drop_predicates_are_implied_by_item_defn`).

Re-expresses the hunk `@@ -135,14 +138,27 @@`: removes the fresh impl args (`fresh_args_for_item`), the `ocx.eq(adt_env, fresh_adt_ty, impl_adt_ty)` equation, and goes back to
`tcx.predicates_of(drop_impl).instantiate_identity(tcx)` (here `clauses_of(..).instantiate_identity`) instead of `.instantiate(tcx, fresh_impl_args)`. So impl predicates are no longer unified with the ADT's env through the self type, and predicates constrained only via associated-type equality are rejected / mis-handled (issues 126378, 126889).
