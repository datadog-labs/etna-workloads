# Adapted injection for Do not duplicate importing suggestion when reporting privacy error

Fix: https://github.com/rust-lang/rust/commit/579efc565531a5657d62cc366e89274d1755acc3

File: compiler/rustc_resolve/src/diagnostics/impls.rs (file moved from diagnostics.rs), report_privacy_error.
Removed `!shown_candidates &&` from the `can_replace_use` condition, re-expressing the fix hunk
`@@ -2476,8 +2479,9 @@` (`let can_replace_use = !shown_candidates && !single_nested && ...`).
Without it, the Directory importing suggestion is emitted even when candidates were already shown. The `shown_candidates` binding (other hunks) is left in place but unused.
