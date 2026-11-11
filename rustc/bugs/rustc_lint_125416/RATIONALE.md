# Adapted injection for Use correct param-env in MissingCopyImplementations

Fix: https://github.com/rust-lang/rust/commit/8369dbba4360f783b84cfb13304329ae1cbd092f

# Rationale
File compiler/rustc_lint/src/builtin.rs, `MissingCopyImplementations::check_item`.
Fix hunk `@@ -674,11 +674,10 @@` replaced `let param_env = ty::ParamEnv::empty();` with `cx.param_env` for
`is_copy_modulo_regions`, `type_implements_negative_copy_modulo_regions` and (later hunk) `type_allowed_to_implement_copy`.
Re-injected: in 1.99.1 these use `cx.type_is_copy_modulo_regions`/`cx.typing_env()` and `cx.param_env`; I introduced
`let empty_env = ty::ParamEnv::empty();` and use it (with `TypingEnv::new(empty_env, cx.typing_mode())`) for the copy check,
the negative-copy check, and `type_allowed_to_implement_copy`. The Iterator check keeps cx.param_env (the hunk at -694 is not reverted; it's not needed for the failure).
