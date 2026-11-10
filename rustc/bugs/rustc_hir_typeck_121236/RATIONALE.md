# Adapted injection for Don't show suggestion if slice pattern is enclosed by any patterns

Fix: https://github.com/rust-lang/rust/commit/78e94cba7733d52f0601d853be15622361d94e44

# Rationale
File: compiler/rustc_hir_typeck/src/pat.rs, fn error_expected_array_or_slice.
Re-expresses fix hunk `@@ -2309,7 +2321,9 @@ ... error_expected_array_or_slice`:
`let is_top_level = current_depth <= 1; if is_slice_or_array_or_vector && is_top_level {`
(before the fix: no depth check, suggestion always shown). Now `is_top_level` is forced to `true`, so the
"consider slicing here" suggestion appears even when the slice pattern is nested inside other patterns.
The depth plumbing hunks already exist in 1.99.1 (current_depth), so only the use site was changed.
