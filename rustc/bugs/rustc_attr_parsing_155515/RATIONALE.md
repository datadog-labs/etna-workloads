# Adapted injection for error on empty `export_name`

Fix: https://github.com/rust-lang/rust/commit/d0ea88eeb72b652aa280a5163634ce9bae8ebf5b

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/codegen_attrs.rs, `ExportNameParser::convert`.
Re-expresses fix hunk `@@ -133,6 +133,12 @@ impl<S: Stage> SingleAttributeParser<S> for ExportNameParser`:
removed the `if name.is_empty() { cx.emit_err(EmptyExportName{..}); return None; }` check, so empty
`export_name` is accepted again. Also dropped the now-unused `EmptyExportName` import (hunk #1 of the fix).
The diagnostic struct itself was left in place (it moved to another file in 1.99.1).
