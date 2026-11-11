# Adapted injection for always check for mixed deref pattern and normal constructors

Fix: https://github.com/rust-lang/rust/commit/50061f3b11f51d7a6e3acd8ce793a1f17f99b597

# Rationale
File: compiler/rustc_pattern_analysis/src/rustc.rs, `RustcPatCtxt::match_may_contain_deref_pats` (1.99.1 successor of the gate in the fix).
Fix hunk `@@ -1055,13 +1070,6 @@ analyze_match`: removed
`if tycx.tcx.features().deref_patterns() { ... detect_mixed_deref_pat_ctors(...) }`, so the check always runs (works for box patterns).
Re-injected: the check is again gated on `features().deref_patterns()` (ANDed into the hook that guards `checks::detect_mixed_deref_pat_ctors` in usefulness.rs), so box patterns mixed with `Box {..}` are no longer rejected without the feature.
