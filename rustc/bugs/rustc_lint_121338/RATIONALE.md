# Adapted injection for Downgrade ambiguous_wide_pointer_comparisons suggestions to MaybeIncorrect

Fix: https://github.com/rust-lang/rust/commit/4d386d9f049da498b5f072b6c358a6fbbe0baf59

# Rationale
File: compiler/rustc_lint/src/diagnostics.rs (the fix's lints.rs moved here in 1.99.1).
Three structs changed from `applicability = "maybe-incorrect"` (with the FIXME(#53934) comment) back to `"machine-applicable"`:
- `AmbiguousWidePointerComparisonsAddrMetadataSuggestion` <-> fix hunk `@@ -1543,7 +1543,8 @@ pub enum AmbiguousWidePointerComparisons<'a>`
- `AmbiguousWidePointerComparisonsAddrSuggestion` <-> fix hunk `@@ -1562,7 +1563,8 @@` (AddrEq variant, now a struct)
- `AmbiguousWidePointerComparisonsCastSuggestion` <-> fix hunk `@@ -1578,7 +1580,8 @@` (Cast variant, now a struct)
The Expect suggestion was not part of the fix and is left unchanged.
Effect: rustfix applies several alternative suggestions together, producing uncompilable code (issue #121330).
