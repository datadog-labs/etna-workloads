# Adapted injection for Rework attribute recovery logic

Fix: https://github.com/rust-lang/rust/commit/0b0e826c0fc09eb54487658ab782e816d92619d6

# Rationale
1.99.1 moved the code: `rustc_attr_parsing/src/parser.rs` `expected_lit` and `rustc_attr_parsing/src/diagnostics.rs` `InvalidMetaItem` (messages.ftl is gone; labels are inline). The `StmtKind::descr` addition in ast.rs is left in place; it is only a helper and removing it is not needed for the bug.

1. parser.rs `MetaItemListParserContext::expected_lit`: restores the pre-fix recovery. It is the hunk `@@ -488,51 +488,55 @@ impl MetaItemListParserContext` (the `-if self.parser.prev_token == token::Eq && let token::Ident(..)`, `-look_ahead(1, Bang)` branches, quoting idents with `while let token::Ident(..)`, and the `token == token::Minus` handling). The new generic stmt-based recovery (`stmt.kind.descr()`, `UnOp::Neg`, etc.) is replaced by the old code. The `label = Some(stmt.span)` field name stays `label` (the rename hunk is `macro_call: None -> label: None`).
2. diagnostics.rs `InvalidMetaItem` label: `.label = {$descr}s are not allowed here` -> `macros are not allowed here` (messages.ftl hunk `@@ -87,7 +87,7 @@`).
