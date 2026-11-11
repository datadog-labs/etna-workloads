# Adapted injection for Turn assert_eq into a delay_span_bug

Fix: https://github.com/rust-lang/rust/commit/62b6529e039ccba88a02e1a2cdff65a7f0d25bef

# Hunk: compiler/rustc_hir_analysis/src/coherence/orphan.rs, `check_impl` (auto-trait branch)
Fix hunk: `@@ -452,7 +452,13 @@ fn lint_auto_trait_impl<'tcx>(` replaced `assert_eq!(trait_ref.args.len(), 1);` with a
`delay_span_bug("auto traits cannot have generic parameters")` + return.
In 1.99.1 `lint_auto_trait_impl` (and the suspicious_auto_trait_impls lint) no longer exists (lint removed),
so the hard assertion is re-added at the start of the `if tcx.trait_is_auto(trait_def_id)` block of the orphan check,
the place that now handles auto-trait impls. `impl<P> Trait<P> for ()` for `auto trait Trait<P>` ICEs on the assert.
