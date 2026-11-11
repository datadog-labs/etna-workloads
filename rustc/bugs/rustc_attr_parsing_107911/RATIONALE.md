# Adapted injection for Add check for invalid \`#[macro_export]\` arguments

Fix: https://github.com/rust-lang/rust/commit/e39fe374df14334be3b5eb081a006fad8e4419f7

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/macro_attrs.rs, `MacroExportParser::convert` (the 1.99.1 home of the logic that check_attr.rs `check_macro_export` had).
The fix's hunk `@@ -2102,7 +2103,33 @@ fn check_macro_export` added `emit_spanned_lint(INVALID_MACRO_EXPORT_ARGUMENTS, ...)` for
`meta_item_list.len() > 1` (TooManyItems) and for `name_or_empty() != sym::local_inner_macros` (UnknownItem).
I removed the `warn_ill_formed_attribute_input(INVALID_MACRO_EXPORT_ARGUMENTS)` calls (and the import), so invalid arguments are silently accepted as "not local_inner_macros", restoring the pre-fix behaviour of no diagnostic.
