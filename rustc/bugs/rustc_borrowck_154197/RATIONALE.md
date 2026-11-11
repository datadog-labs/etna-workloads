# Adapted injection for Address custom type implementing Derefs to suggest UFCS clone

Fix: https://github.com/rust-lang/rust/commit/61ff157bd47ce626795f1672d6cc7bf3ba292fd6

Hunk: compiler/rustc_borrowck/src/diagnostics/move_errors.rs, `add_move_hints` (+ removed `suggest_cloning_through_overloaded_deref`, trimmed import of `BorrowedContentSource`).
Re-expresses fix hunks `@@ -686,12 +690,48 @@` (added suggest_cloning_through_overloaded_deref, UFCS `<{ty} as Clone>::clone(&..)`) and `@@ -735,15 +775,42 @@` (the `needs_ufcs` check + `emitted_ufcs`). Reverted: the move through an overloaded Deref now only gets the plain `.clone()` suggestion via `suggest_cloning` (the buggy parent behaviour, which clones the wrapper).
