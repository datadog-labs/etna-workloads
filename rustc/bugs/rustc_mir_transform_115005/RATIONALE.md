# Adapted injection for Don't do intra-pass validation on MIR shims

Fix: https://github.com/rust-lang/rust/commit/acd3542b8d4cf9b4bc1cf6c99f76bb2fb938fe20

# Hunk: compiler/rustc_mir_transform/src/shim.rs, make_shim
Re-expresses fix hunk `@@ -90,7 +90,11 @@ fn make_shim`: `-    pm::run_passes(` / `+    pm::run_passes_no_validate(` (plus comment).
Restored the buggy `pm::run_passes(` (intra-pass validation on) for the shim pass list and removed the explaining comment. With TAITs, validation uses a user-facing param-env and errors.
