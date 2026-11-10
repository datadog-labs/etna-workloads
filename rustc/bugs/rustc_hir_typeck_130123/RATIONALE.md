# Adapted injection for Report the `note` when specified in `diagnostic::on_unimplemented`

Fix: https://github.com/rust-lang/rust/commit/4cecf429717ceab06007570fd699086a0855a027

# Hunk
File: compiler/rustc_hir_typeck/src/method/suggest.rs, the function that reports unsatisfied trait bounds for E0599 (around line 2209 in 1.99.1).
The fix's last hunk (`@@ -1363,6 +1363,10 @@`) added `for note in notes { err.note(note); }`. I removed that loop and left `let _ = notes;`. The `notes` tuple plumbing from the other two hunks was already present in 1.99.1, so I left it alone.
The `note = "..."` from `diagnostic::on_unimplemented` is therefore dropped again.
