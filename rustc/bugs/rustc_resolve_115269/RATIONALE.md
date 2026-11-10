# Adapted injection for resolve: determined binding after parent module macro expand

Fix: https://github.com/rust-lang/rust/commit/f1536507e12a8039bed5a5f1b1d4aebfb678607b

# Rationale
One hunk: compiler/rustc_resolve/src/ident.rs, `resolve_ident_in_module_globs_unadjusted`.
Re-expresses fix hunk `@@ -972,9 +972,8 @@` in ident.rs:
-        let unexpanded_macros = !module.unexpanded_invocations.borrow().is_empty();
-            if !unexpanded_macros || ns == MacroNS || restricted_shadowing {
+            if binding.determined() || ns == MacroNS || restricted_shadowing {
In 1.99.1 the check is `binding.determined(&self)`; I restored the old module-wide
`!module.has_unexpanded_invocations(&self)`, so a glob binding is treated as determined purely
by whether the module has no unexpanded macros, ignoring whether the glob's own parent module does.
