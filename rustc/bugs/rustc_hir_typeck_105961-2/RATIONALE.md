# Adapted injection for Use InferCtxt::probe to properly detect ambiguous candidates

Fix: https://github.com/rust-lang/rust/commit/6065867a7e4379a12e495912a41318f871104270

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/mod.rs, `select_inherent_assoc_candidates` (the 1.99.1 home of the old astconv `probe_inherent_assoc_type` logic).

Fix hunk `@@ -2235,35 +2235,40 @@ impl<'o, 'tcx> dyn AstConv<'tcx> + 'o` wrapped the per-candidate check in `infcx.probe(|_| { let ocx = ObligationCtxt::new_in_snapshot(&infcx); ... })`, so inference variables unified for one candidate were rolled back before testing the next.
In 1.99.1 the check is the closure `filter_iat_candidate`, called as `infcx.probe(|_| filter_iat_candidate(self_ty, impl_))`. I removed the `infcx.probe`, calling `filter_iat_candidate(self_ty, impl_)` directly. Inference side effects now leak between candidates: for `Wrapper<_>::Foo`, the first impl unifies `_ = i32`, the second then fails, so the ambiguity is missed.
