# Adapted injection for Unconditionally run `RevealAll` pass and run it earlier

Fix: https://github.com/rust-lang/rust/commit/f5df26dbecf39dccd0833a3a82eb1aea3d127e17

In 1.99.1 `reveal_all.rs`/`RevealAll` is now `post_analysis_normalize.rs`/`PostAnalysisNormalize`.

1. compiler/rustc_mir_transform/src/lib.rs, `run_runtime_lowering_passes`: removed PostAnalysisNormalize from the lowering list (so it no longer runs before ElaborateDrops). Re-expresses hunk `@@ -480,6 +480,7 @@ fn run_runtime_lowering_passes` (fix added `&reveal_all::RevealAll, // has to be done before drop elaboration`).
2. lib.rs, `run_optimization_passes`: re-added the pass before `Inline`. Re-expresses `@@ -526,7 +527,6 @@ fn run_optimization_passes` (fix removed `&reveal_all::RevealAll, // has to be done before inlining`).
3. post_analysis_normalize.rs, `policy`: from Required to optional, enabled only if mir_opt_level >= 3 or Inline enabled. Re-expresses the removal of `fn is_enabled` (`sess.mir_opt_level() >= 3 || super::inline::Inline.is_enabled(sess)`) in reveal_all.rs.
