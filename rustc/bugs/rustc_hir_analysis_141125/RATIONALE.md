# Adapted injection for check coroutines with TypingMode::Borrowck to avoid cyclic reasoning

Fix: https://github.com/rust-lang/rust/commit/667504b176c9e1ab380cef6eb9eaeba4813337c3

# Rationale
File: compiler/rustc_hir_analysis/src/check/check.rs, fn `check_coroutine_obligations` (one function, two edits).

1. Typing mode: with next solver, use `TypingMode::post_borrowck_analysis(tcx, def_id)` instead of `TypingMode::borrowck(tcx, def_id)`.
   Re-expresses fix hunk `@@ -1754,17 +1754,19 @@` (`-TypingMode::post_borrowck_analysis(tcx, def_id)` / `+TypingMode::borrowck(tcx, def_id)`). Coroutine obligations are again checked with borrowck-inferred opaque types, causing cyclic reasoning.
2. Removed the `else { let _ = infcx.take_opaque_types(); }` branch, re-expressing hunk `@@ -1785,6 +1787,10 @@`.
   (The comment-only changes of the fix are not behavioural.)
