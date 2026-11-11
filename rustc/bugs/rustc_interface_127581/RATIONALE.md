# Adapted injection for Reject macro calls inside of `#![crate_name]`

Fix: https://github.com/rust-lang/rust/commit/9b6fd35738965ef3f246018fddc743b5e5cd8d2c

# Rationale
One hunk: compiler/rustc_interface/src/passes.rs, `get_crate_name`.
The fix introduced `get_crate_name` / `validate_and_find_value_str_builtin_attr` (hunk `@@ -1080,23 +1081,85 @@ start_codegen`), which validates every `#![crate_name]` and fatally rejects malformed ones (e.g. macro calls) before expansion. In 1.99.1 that validation is `parse_crate_name(..., ShouldEmit::EarlyFatal { also_emit_lints: true })`. I changed it to `ShouldEmit::Nothing`, so malformed `#![crate_name = concat!(..)]` is silently ignored (pre-fix behaviour).
