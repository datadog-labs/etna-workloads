# Adapted injection for Modify existing bounds if they exist

Fix: https://github.com/rust-lang/rust/commit/af5a37e8440c503b5bb89ec94199f036d772b9e8

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs, `note_and_explain_type_err` (ty::Param vs Alias projection arm).
Both `suggest_constraining_type_param(..., None, matching_span)` calls now pass `None` as the span_to_replace argument instead of `matching_span`.
This re-expresses the fix hunk `@@ -77,49 +77,86 @@ impl<'tcx> TypeErrCtxt<'_, 'tcx>` in note_and_explain.rs, which began finding an existing bound and passing its span so the existing bound is modified (`span_to_replace`). With None, a new `+ Trait<..>` bound is always added (the old behaviour).
