# Adapted injection for Normalize in infcx instead of globally for `Option::as_deref` suggestion

Fix: https://github.com/rust-lang/rust/commit/c12575d3173eb6ba985482808a87e54f23ad328e

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn suggest_option_method_if_applicable (the `Option::as_deref` suggestion).

Re-expresses the single fix hunk `@@ -3592,7 +3592,8 @@`:
- removed `let Ok(deref_target) = tcx.try_normalize_erasing_regions(param_env, projection)` (old)
- fix added `let InferOk { value: deref_target, obligations } = infcx.at(..).normalize(projection)` + `obligations.iter().all(..predicate_must_hold_modulo_regions..)`.
I restored the old global `tcx.try_normalize_erasing_regions(TypingEnv::new(param_env, non_body_analysis), ..)`, dropping the infcx normalize and obligation check. Inference vars in the projection are then not handled by the global normalizer (the ICE of issue 112293).
