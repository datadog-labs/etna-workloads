# Adapted injection for fix(expand): prevent infinity loop in macro containing only "///"

Fix: https://github.com/rust-lang/rust/commit/c927743b7b7bd382836dcce2d1140a7e829dc3d0

# Rationale
compiler/rustc_expand/src/mbe/macro_rules.rs, `is_empty_token_tree` (1.99.1 successor of `check_lhs_no_empty_seq`):
removed the `mbe::TokenTree::Token(Token{kind: DocComment(..),..})` arm (including the note about ignored doc comments),
so a doc comment in a repetition counts as non-empty again. This re-expresses the fix hunk
`@@ -647,6 +647,7 @@ fn check_lhs_no_empty_seq` adding `TokenTree::Token(t) => matches!(t, Token { kind: DocComment(..), .. }),`.
Result: `$(///)*` is not rejected as an empty repetition, so the matcher loops forever (the original bug).
The #[derive(Debug)] hunk in macro_parser.rs is not behavioural.
