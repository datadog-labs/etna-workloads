# Adapted injection for Fix `unused_braces` lint suggestion when encountering attributes

Fix: https://github.com/rust-lang/rust/commit/4765fd6b76835058044bed2a25acd1c6335332e4

compiler/rustc_lint/src/unused.rs, `emit_unused_delims_expr`: in the `ExprKind::Block(.., None)` single-stmt arm, dropped the attribute-aware span (`stmt.attrs()...min()` -> `stmt.span.with_lo(attr_lo)`) and use plain `stmt.span` again. Re-expresses fix hunk `@@ -780,26 +779,30 @@ trait UnusedDelimLint` (the added `// For the statements with attributes ... stmt.span.with_lo(attr_lo)` block). The suggestion now removes the attributes.
