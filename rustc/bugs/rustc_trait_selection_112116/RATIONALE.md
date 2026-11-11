# Adapted injection for Don't suggest cyclic associated type constraint

Fix: https://github.com/rust-lang/rust/commit/c92140e83831286c36882fa50cc9edc0ecbbc578

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs, fn `expected_projection` (moved from rustc_infer in 1.99.1).

Removed the early return
`if erase_and_anonymize_regions(values.found).contains(erase_and_anonymize_regions(values.expected)) { return; }`.
This re-expresses the fix hunk `@@ -374,12 +374,18 @@` which added
`// Don't suggest constraining a projection to something containing itself` / `if ...found.contains(...expected) { return; }`.
Without it, a cyclic "consider constraining the associated type" suggestion is emitted again.
