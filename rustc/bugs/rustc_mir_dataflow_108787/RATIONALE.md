# Adapted injection for Erase lifetimes in SROA.

Fix: https://github.com/rust-lang/rust/commit/fc1a861558a49013fb6af5e4c36450a3b96ddc03

# Rationale
Fix hunks: value_analysis.rs `@@ -956,14 +957,14 @@ iter_fields` (`.try_normalize_erasing_regions(param_env, field_ty).unwrap_or_else(|_| tcx.erase_regions(field_ty))` replacing `.unwrap_or(field_ty)`), and sroa.rs `@@ -18,11 +18,12 @@ run_pass` (`let param_env = tcx.param_env_reveal_all_normalized(...)` passed to compute_flattening).

1. rustc_mir_dataflow/src/value_analysis.rs, `iter_fields`: on normalization failure, fall back to the unerased `field_ty` (old `.unwrap_or(field_ty)`) instead of `erase_and_anonymize_regions`, so lifetimes leak into SROA locals.
2. rustc_mir_transform/src/sroa.rs, `run_pass`: `typing_env` is `TypingEnv::fully_monomorphized()` instead of `body.typing_env(tcx)`, so the body's param env is not used (old code used a generic reveal_all env), making normalization of e.g. `<T as Err>::Err` fail and trigger the unerased fallback.
