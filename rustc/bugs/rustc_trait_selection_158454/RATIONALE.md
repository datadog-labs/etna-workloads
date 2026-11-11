# Adapted injection for fix: don't produce invalid `Trait<A><B>` in "consider further restricting this bound" suggestion

Fix: https://github.com/rust-lang/rust/commit/9260f2ee472d875b7e9731d109fc76ba2b4f0202

# Rationale
In 1.99.1 `compiler/rustc_middle/src/ty/diagnostics.rs::suggest_constraining_type_params` already matched the pre-fix code
(the fix hunk `@@ -398,15 +398,28 @@` with `strip_prefix('<')` / `span_to_snippet(... BytePos(1)) == Ok(">")` was absent),
yet the test passed because the caller `compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs`
(projection mismatch suggestion) separately computes the end of existing generic args and emits `, Right = B`
(matched_end_of_args path). That is the behaviour the fix guaranteed (merge into the existing arg list, not `Trait<A><B>`).

Hunk: note_and_explain.rs, the `if let Some((end_of_trait, end_of_args)) = potential_spans` block.
Removed the "insertion point is inside existing args" detection: `matching_span` is now always the end of the
whole bound path (after `>`) and `matched_end_of_args` stays false, so the `<Right = B>` form is inserted after
the existing `<Left = A>`, yielding `Pair<Left = A><Right = B>`.
This re-expresses the fix hunk's "if the insertion point immediately follows `>`, merge as `, {rest}`" logic by undoing it.
