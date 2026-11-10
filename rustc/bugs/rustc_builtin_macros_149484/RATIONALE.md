# Adapted injection for Supress some lookup errors if a module contains `compile_error!`

Fix: https://github.com/rust-lang/rust/commit/f3e73dced1144f3b7cc81b34c45fdafec66e29f2

# Rationale
File: compiler/rustc_builtin_macros/src/compile_error.rs, fn expand_compile_error.
Removed the line `cx.resolver.mark_scope_with_compile_error(cx.current_expansion.lint_node_id);`,
re-expressing the fix hunk `@@ -22,6 +22,7 @@ pub(crate) fn expand_compile_error` which added it.
Without it, modules containing compile_error! are never recorded in mods_with_parse_errors, so lookup errors are no longer suppressed.
The other fix hunks (base.rs trait method, macros.rs impl, ident.rs) are already in 1.99.1 and left untouched (now unused by the caller).
