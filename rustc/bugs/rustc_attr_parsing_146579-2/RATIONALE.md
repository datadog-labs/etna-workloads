# Adapted injection for Handle macro invocation in attribute during parse

Fix: https://github.com/rust-lang/rust/commit/01e2cf8f44b0d99c019f292140cfc58b9bc67501

Hunk: compiler/rustc_attr_parsing/src/parser.rs, `MetaItemListParserContext::expected_lit`.
Fix hunk `@@ -496,20 +497,37 @@` added a branch for `look_ahead(1, Bang)` that parses the macro call as a stmt
(descr "macro ...", label span). The 1.99.1 code handles this generically via parse_stmt_without_recovery.
Re-injected the old behaviour: when prev token is `=` and token is an Ident followed by `!`, skip the
stmt parse, bump idents and emit a quote_ident_sugg (the pre-fix `while let token::Ident(..) { bump }` path), so no macro label/descr is produced.
