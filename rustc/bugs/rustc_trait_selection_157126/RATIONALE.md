# Adapted injection for Avoid redundant note when a #[derive] is already suggested

Fix: https://github.com/rust-lang/rust/commit/8685d8fd39da30b1b26fb0e656caf5b6fe540244

Hunk: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, report_selection_error (E0277 branch).
Fix hunk `@@ -448,8 +448,21 @@` added `derive_suggestion_will_be_shown` (main==leaf predicate && can_suggest_derive) and skipped `err.note(note)` for on_unimplemented notes when true. Reinjected by removing that computation and the skip, so the note is always emitted (redundant with the derive suggestion).
