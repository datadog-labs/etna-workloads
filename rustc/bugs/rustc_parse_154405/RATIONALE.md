# Adapted injection for Improve doc comment unicode guidance

Fix: https://github.com/rust-lang/rust/commit/16b9fddf001a7f024f300e2bffa43203ff271318

# Rationale
compiler/rustc_parse/src/lexer/mod.rs, in the doc-comment branch that calls `report_text_direction_codepoint(..., "doc comment")`: the `is_doc_comment` argument is passed as `false` instead of `true`.
This re-expresses the fix hunk `@@ -546,6 +546,7 @@ impl<'psess, 'src> Lexer` (`+ true,` before `"doc comment"`). With `false`, `NoEscape` uses the generic "you can escape them" note instead of the doc-comment-specific `#[doc = "..."]` guidance. In 1.99.1 the errors.rs code lives in diagnostics.rs and already has the `is_doc_comment` field; only this call-site value was changed.
