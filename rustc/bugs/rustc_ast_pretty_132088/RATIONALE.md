# Adapted injection for Print safety correctly in extern static items

Fix: https://github.com/rust-lang/rust/commit/4e1b3ab0e7965b8cce016f1ca01cd2df37e11635

# Rationale
All changes in compiler/rustc_ast_pretty/src/pprust/state/item.rs (reverse of the fix):
- `print_foreign_item` (Static arm): fix hunk `@@ -38,7 +38,6 @@` / `@@ -46,6 +45,7 @@` removed `self.print_safety(*safety);` and passed `*safety` to print_item_const. Reversed: print_safety is called before print_item_const (i.e. before the visibility, giving `unsafe pub static`), and `*safety` is no longer passed.
- `print_item_const`: fix hunk `@@ -84,10 +84,12 @@` added `safety: ast::Safety` param and `self.print_safety(safety)` after print_visibility. Both removed.
- `print_item` (two calls) and the assoc-item call: fix hunks `@@ -181`, `@@ -192`, `@@ -549` added `ast::Safety::Default,` args; removed.
