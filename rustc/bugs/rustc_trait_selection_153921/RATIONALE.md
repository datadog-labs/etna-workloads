# Adapted injection for Suppress self-referential associated type constraint suggestion

Fix: https://github.com/rust-lang/rust/commit/4ecc78d637204bc3690ad0cd733671ce7b7e36ea

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs, fn note_and_explain_type_err, the `(_, ty::Alias(Projection|Inherent ..))` match arm.
Fix hunk `@@ -263,8 +263,13 @@` added the guard
`&& !erase_and_anonymize_regions(values.expected).contains(erase_and_anonymize_regions(values.found))`
(plus a comment). In 1.99.1 the arm was reshaped, with the guard intact; I removed that guard so the arm again
suggests self-referential constraints like `Item = &<I as Iterator>::Item`. The comment was left in place.
