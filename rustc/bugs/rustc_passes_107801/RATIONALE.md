# Adapted injection for const_eval: `implies_by` in `rustc_const_unstable`

Fix: https://github.com/rust-lang/rust/commit/912783402fe2f0d1fff41b047b0918e7e58e18ae

# Rationale
One hunk: compiler/rustc_passes/src/stability.rs, `stability_implications` (closure `register_implication`).
I removed the block that registers `implied_by` from `lookup_const_stability(def_id)` into `implications`.
This re-expresses the fix hunk `@@ -265,6 +265,15 @@ impl Annotator` in rustc_passes/src/stability.rs, which added
`if let Some(ConstStability { level: Unstable { implied_by: Some(implied_by), .. }, feature, .. }) = const_stab { self.index.implications.insert(implied_by, feature); }`.
The fn_queries.rs / check.rs hunks have already been merged into 1.99.1's check.rs in a different form, so I left them alone.
