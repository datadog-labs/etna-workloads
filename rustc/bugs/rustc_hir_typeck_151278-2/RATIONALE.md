# Adapted injection for On E0308 caused by cloning a reference due to missing bounds, account for derive

Fix: https://github.com/rust-lang/rust/commit/085da0cee4e6de6408c401ea2a807eff6b701307

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, function that emits the "type is not Clone" note (the `type_implements_trait_shallow` block).
Re-expresses the fix hunk `@@ -1932,25 +1932,96 @@` (the hunk that added `manually_impl`, the `ImplDerived` handling, and `suggest_derive = false`).
Restored the old behaviour: the single-error and multi-error arms emit the plain "`Clone` is not implemented because the trait bound(s) ... " help text. They no longer use the ImplDerived spans, the "derive introduces an implicit ..." labels, or the "consider manually implementing `Clone`" help. `suggest_derive` stays true, which re-expresses the second hunk (`if suggest_derive { self.suggest_derive(..) }`).
