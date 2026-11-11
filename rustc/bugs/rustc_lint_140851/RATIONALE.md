# Adapted injection for Warn when #[export_name] is used with generic functions

Fix: https://github.com/rust-lang/rust/commit/0de994a368e9225fab812a7295f9350285cd55d3

In compiler/rustc_lint/src/builtin.rs, `InvalidNoMangleItems::check_item` (ItemKind::Fn) and `check_impl_item` (ImplItemKind::Fn) now look only for `NoMangle`, not `ExportName`.
This re-expresses fix hunks `@@ -1019,8 +1023,10 @@` (`find_by_name(attrs, sym::export_name).or_else(|| ...no_mangle)` in Fn items) and `@@ -1048,11 +1054,12 @@` (same for impl items). Without them, `#[export_name]` on generic fns no longer triggers the lint.
The doc/rename hunks are cosmetic and were not reverted.
