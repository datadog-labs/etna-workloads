# Adapted injection for Validate crate name in CLI option --extern

Fix: https://github.com/rust-lang/rust/commit/8d81d5a909551631b51177f976f68ac02dcafd11

# Rationale
File: compiler/rustc_session/src/config/externs.rs, fn `split_extern_opt` (the code that used to live in `parse_externs` in config.rs).
Removed the `if !valid_crate_name(&crate_name, unstable_opts) { ... }` block that emits
"crate name `{crate_name}` passed to `--extern` is not a valid ASCII identifier" (+ dash->underscore help).
Re-expresses fix hunk `@@ -2451,6 +2451,19 @@ pub fn parse_externs(` which added `if !crate::utils::is_ascii_ident(&name) { ... error.emit(); }`.
The helper functions (the fix's session.rs `early_struct_error` and utils.rs `is_ascii_ident` hunks) remain since they are still used elsewhere / only produce a dead-code warning.
