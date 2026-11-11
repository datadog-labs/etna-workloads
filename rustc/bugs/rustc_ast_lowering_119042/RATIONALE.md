# Adapted injection for fallback `default` to `None` during ast-loweing for lifetime binder

Fix: https://github.com/rust-lang/rust/commit/e16efbd23afe98d1bda104d850e0285591d3a5d8

# Rationale
File: compiler/rustc_ast_lowering/src/lib.rs, fn `lower_generic_param_kind` (the `GenericParamKind::Type` arm).
The fix (hunk `@@ -878,8 +880,27 @@ lower_lifetime_binder`) made lowering of non-lifetime binder params emit
"default parameter is not allowed in this binder" and fall back to `default: None`.
In 1.99.1 that logic lives in the `.filter(|_| match source { Binder => emit_err(GenericParamDefaultInBinder); false })`
on the type default. I removed the filter, so a type default in a `for<>` binder is lowered into HIR with no error (the pre-fix behaviour).
Const-param handling is left untouched.
