# Adapted injection for fix(hir_analysis/wfcheck): don't leak {type error}

Fix: https://github.com/rust-lang/rust/commit/c5598d6a9e0e8a46775f2c69e1278efee8223425

Single file: compiler/rustc_hir_analysis/src/check/wfcheck.rs, fn check_param_wf (const param type check, `_` arm).
Re-expresses fix hunk `@@ -961,13 +961,20 @@ fn check_param_wf`:
- removed `ty.error_reported()?;` (the "Avoid showing {type error}" guard) so error types leak into "`{type error}` is forbidden..." message.
- restored old note text "integers, `bool` and `char`" (fix changed it to "`bool`, and `char`").
