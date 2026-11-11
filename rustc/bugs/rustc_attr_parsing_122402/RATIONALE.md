# Adapted injection for Make `#[diagnostic::on_unimplemented]` format string parsing more robust

Fix: https://github.com/rust-lang/rust/commit/5568c569c03c8c22ce81185b9e49efcaa6866050

# Hunk: compiler/rustc_attr_parsing/src/attributes/diagnostic/mod.rs, `parse_arg`
Changed `if check_format {` to `if false && check_format {`, so `warn_on_format_spec` is never called and format specifiers (e.g. `{Self:123}`, `{1:}`) in `#[diagnostic::on_unimplemented]` no longer produce the "format specifiers are not permitted" lint.
Re-expresses the fix hunk in on_unimplemented.rs (`Piece::NextArgument(a) => { let format_spec = a.format; if self.is_diagnostic_namespace_variant && (format_spec.ty_span.is_some() ...) { emit ... InvalidFormatSpecifier`), which added the specifier warning. The parent lacked it.
