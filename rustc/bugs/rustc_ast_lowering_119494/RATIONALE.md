# Adapted injection for Deny defaults for higher-ranked generic parameters

Fix: https://github.com/rust-lang/rust/commit/3d0297a1e1b74ab50b97f78cf4fd056cb0ed51a7

# Hunk: compiler/rustc_ast_lowering/src/lib.rs, lower_generic_param_kind (GenericParamKind::Type arm)
Fix hunk `@@ -2173,22 +2154,51 @@` added a `.filter(|_| match source { Generics => true, Binder => { emit_err(GenericParamDefaultInBinder); false } })`
so type-param defaults in `for<...>` binders are denied and mapped to None. Re-injected bug: the Binder arm now returns `true`
(no error, default kept), as before the fix (when binders lowered defaults without the dedicated diagnostic).
The const-param arm is unchanged.
