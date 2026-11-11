# Adapted injection for If suggestion would leave an empty line, delete it

Fix: https://github.com/rust-lang/rust/commit/367126d49af3237eee24889191dfbb02dfc9320c

# Rationale
compiler/rustc_errors/src/json.rs, `DiagnosticSpan::from_span_full`: removed the block
(`if start.col.0 == 0 && suggestion is empty && span_to_next_source(span) starts_with('\n') { span = span.with_hi(span.hi()+1) }`)
which re-expresses the fix hunk `@@ -436,6 +436,16 @@ fn from_span_full` (which added that block and `mut span`; `mut span` is still needed in 1.99.1 for the dummy-source-map case, so kept).
Result: removal suggestions leave an empty line again.
