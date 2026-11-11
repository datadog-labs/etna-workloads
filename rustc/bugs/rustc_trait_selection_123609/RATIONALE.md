# Adapted injection for Don't use bytepos offsets when computing semicolon span for removal

Fix: https://github.com/rust-lang/rust/commit/a439eb259da620fa95c67c0c6e89f196bcb61f08

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/suggest.rs, fn `could_remove_semicolon` (moved from rustc_infer in 1.99.1).
Fix hunk `@@ -763,8 +763,15 @@ impl<'tcx> TypeErrCtxt` replaced `last_stmt.span.with_lo(last_stmt.span.hi() - BytePos(1))` with a `span_extend_while(last_expr.span, whitespace).shrink_to_hi().with_hi(last_stmt.span.hi())`. I restored the old byte-offset line (`rustc_span::BytePos(1)` used by full path), so a multi-byte `;` (Greek question mark) yields a span not on a char boundary.
