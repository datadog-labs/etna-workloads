# Adapted injection for Set !const_evaluatable if ambig. and not inferred

Fix: https://github.com/rust-lang/rust/commit/b79a9a0900dd1d29d8bf49e73b5ac75acafd9c3b

# Hunk: compiler/rustc_trait_selection/src/traits/const_evaluatable.rs, `satisfied_from_param_env`
Re-expresses fix hunk `@@ -215,18 +215,16 @@ fn satisfied_from_param_env<'tcx>(`, which replaced
`if let Some(c) = single_match { if let Ok(c) = c { ...assert... } return true; }` with
`if let Some(Ok(c)) = single_match { ...; return true; }`.
The buggy version returns `true` (const is evaluatable) also when `single_match` is `Some(Err(()))`,
i.e. multiple distinct candidate bounds matched ambiguously and nothing was inferred. That yields an ICE/missed
"unconstrained generic constant" error. Restored the nested form (1.99.1 code uses ObligationCtxt::new + evaluate_obligations_error_on_ambiguity instead of the old commit_if_ok body).
