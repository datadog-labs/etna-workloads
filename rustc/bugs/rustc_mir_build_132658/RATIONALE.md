# Adapted injection for Detect const in pattern with typo

Fix: https://github.com/rust-lang/rust/commit/2487765b88fd9122fcaf57dca94024d81183d272

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, fn report_unreachable_pattern.
Removed the call `find_fallback_pattern_typo(cx, hir_id, pat, &mut lint);` in the
`[covering_pat] if pat_is_catchall(covering_pat)` arm. Re-expresses fix hunk
`@@ -976,7 +984,10 @@ fn report_unreachable_pattern` (added `find_fallback_pattern_typo(...)` call; the old code only set `covered_by_catchall`).
Added `#[allow(dead_code)]` on `find_fallback_pattern_typo` (now uncalled) so the build has no warning; it is otherwise unchanged.
Result: no "did you mean constant" suggestions/notes for a typo'd const in a pattern.
