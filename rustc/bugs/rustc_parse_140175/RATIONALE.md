# Adapted injection for rc and cr more clear error message

Fix: https://github.com/rust-lang/rust/commit/44b19e5fe7c0fe91b4aa8a09c673b340f3177c64

# Rationale
File compiler/rustc_parse/src/lexer/mod.rs, fn `report_unknown_prefix`: removed the
`else if prefix == "rc" { Some(UnknownPrefixSugg::UseCr(prefix_span)) }` branch.
Re-expresses fix hunk `@@ -789,13 +788,14 @@ fn report_unknown_prefix` which added
`} else if prefix == "rc" { Some(errors::UnknownPrefixSugg::UseCr(prefix_span))`.
Without it, `rc"abc"` gets no "use `cr` for a raw C-string" suggestion. The ftl/errors.rs hunks (UseCr variant) are left in place (unused variant only).
