# Adapted injection for discard invalid spans in external blocks

Fix: https://github.com/rust-lang/rust/commit/4138702621f32528fee8bf55eb1b8c0b99ac369b

Two hunks, reverting the fix:
1. compiler/rustc_parse/src/diagnostics.rs, struct ExternItemCannotBeConst: `const_span: Option<Span>` -> `Span`
   (fix hunk `@@ -1676,7 +1676,7 @@ pub(crate) struct ExternItemCannotBeConst`, `-pub const_span: Span` / `+Option<Span>`).
2. compiler/rustc_parse/src/parser/item.rs, parse_foreign_item: const_span is again `span.with_hi(ident.span.lo())`
   without the `.filter(|span| span.can_be_used_for_suggestions())` (fix hunk `@@ -1143,9 +1143,11 @@`). Dummy/macro spans are used in suggestions, causing an ICE.
