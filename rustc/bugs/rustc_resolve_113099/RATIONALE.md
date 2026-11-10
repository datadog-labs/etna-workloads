# Adapted injection for fix(resolve): update the ambiguity glob binding as warning recursively

Fix: https://github.com/rust-lang/rust/commit/cac0bd0bef0661948f558592f43908221e52e2a0

# Re-injection
One hunk: compiler/rustc_resolve/src/lib.rs, `Resolver::record_use`.
The final `self.record_use(ident, source_decl, Used::Other)` (recursing through import layers so the ambiguity
stored on a deeper glob binding is reported) is now skipped when `source_decl.is_glob_import()`.

Re-expresses the fix (title "update the ambiguity glob binding as warning recursively"), mainly the
`imports.rs` hunks `@@ -308,15 +311,42 @@` (`update_resolution`/`try_define`: `} else if binding.is_ambiguity() { resolution.binding = Some(... warn_ambiguity: true ...)`)
and `@@ -459,7 +459,12 @@` (re-defining into glob importers with `warn_ambiguity`). In 1.99.1 that logic was rewritten
(`select_glob_decl`, `update_local_resolution`, ambiguity propagated via recursion in `record_use`),
so the ambiguity of an outer glob re-export is lost when the recursion into glob layers is cut: the old bug
(ambiguity between glob imports not reported through re-exporting globs, e.g. `use openssl::*; id()`).
Edits to `select_glob_decl` in imports.rs alone did not fail any oracle test and were reverted.
