# Adapted injection for Add test for `#![doc(test(...)]` with literal parameter

Fix: https://github.com/rust-lang/rust/commit/70bbcceaeccc529670f9c9d60cd4fb038ee49fe4

# Rationale
Fix diff only reorders `passes_doc_test_literal` in messages.ftl and adds tests/ui/attributes/doc-test-literal.rs
(`#![doc(test(""))]` must give an `invalid_doc_attributes` error for a literal; hunk `@@ -211,11 +211,11 @@` with
`+passes_doc_test_literal = ...`). The message moved to rustc_attr_parsing; on 1.99.1 the literal diagnostic is emitted in
`DocParser::accept` / `Some(sym::test)` arm of compiler/rustc_attr_parsing/src/attributes/doc.rs.
Change: the `MetaItemOrLitParser::Lit` arm no longer emits the lint (literal inside `doc(test(...))` silently accepted),
re-introducing the bug that the literal handling (issue 109066) guards.
