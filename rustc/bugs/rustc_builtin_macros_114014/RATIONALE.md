# Adapted injection for builtin_macros: expect raw strings too

Fix: https://github.com/rust-lang/rust/commit/c06a7eb2a6dcbc7649de76472f6845e30f2fb97f

# Rationale
File compiler/rustc_builtin_macros/src/env.rs, fn `expand_env` (Err branch of the `lookup_env` match, ~line 138).
Changed `kind: LitKind::Str | LitKind::StrRaw(..)` to `kind: LitKind::Str`, so a raw-string var name hits the `unreachable!` (ICE).
Re-expresses fix hunk `@@ -84,7 +84,7 @@ pub fn expand_env` which changed `kind: ast::token::LitKind::Str,` to `Str | StrRaw(..)`.
