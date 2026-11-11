# Adapted injection for iat selection: erase regions in self type

Fix: https://github.com/rust-lang/rust/commit/293f21c876278df7943eea889dacd977155a2f62

# Rationale
The fix (`@@ -2226,47 +2227,66 @@ ... let mut applicable_candidates ... infcx.probe(|_| { let universe = infcx.create_next_universe(); // Regions are not considered during selection. let self_ty = tcx.replace_escaping_bound_vars_uncached(self_ty, FnMutDelegate{regions: re_erased, types/consts: placeholders})`) made IAT candidate selection replace escaping bound vars/regions in the self type (regions erased, types/consts placeholders). In 1.99.1 that logic lives in two `select_inherent_assoc_candidates` impls.

1. `compiler/rustc_hir_typeck/src/fn_ctxt/mod.rs`, `FnCtxt::select_inherent_assoc_candidates`: removed the `traits::with_replaced_escaping_bound_vars` wrapper (the modern form of the fix's `replace_escaping_bound_vars_uncached` block, i.e. its `+ let universe ... + self_ty = ...` hunk) so escaping-bound-var self types go directly into the filter.
2. `compiler/rustc_hir_analysis/src/collect.rs`, `ItemCtxt::select_inherent_assoc_candidates`: the item-level path (the one the oracle tests hit) copes with escaping bound vars via `DeepRejectCtxt`. Re-expressed the unhandled state by asserting `!self_ty.has_escaping_bound_vars()` in the filter, so self types with unreplaced bound vars/regions (`for<T> Lexer<T>::Cursor`, `Lexer<'_>::Cursor`) ICE, as they did before the fix.
