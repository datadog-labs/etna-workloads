# Adapted injection for Don't ICE when encountering unresolved regions in fully_resolve

Fix: https://github.com/rust-lang/rust/commit/ea73f10867e104ec5bb0ef2e83c2e330adc16758

# Rationale
File: compiler/rustc_infer/src/infer/mod.rs, `InferCtxt::fully_resolve`.
Re-expresses hunk `@@ -1422,12 +1422,25 @@ impl<'tcx> InferCtxt<'tcx>`: the fix replaced
`assert!(value.map_or(true, |v| !v.has_infer()), "... is not fully resolved")` with a match that
only bugs on non-region infer vars and replaces leftover region vars with error regions (delayed bug).
I restored the old strict assert (ICE on any unresolved region). The `DUMMY_SP` import hunk is not needed
(1.99.1 uses dcx().delayed_bug). The lint doc-comment hunk is irrelevant.
