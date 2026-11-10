# Adapted injection for Fix multiple `expect` attribs in impl block

Fix: https://github.com/rust-lang/rust/commit/b56a04975c8c77b14a474fe3b38573872a065971

# Rationale
Fix added `insert_fulfilled_expectation` and, in `DeadVisitor::warn_multiple` (dead.rs, `@@ -814,6 +814,13 @@`), marked the expectations of `dead_codes[1..]` as fulfilled, since one lint was emitted for the whole group. In 1.99.1 this was rewritten: dead items are grouped by `level_plus = (Level, Option<StableLintExpectationId>)` so each `#[expect]` gets its own diagnostic.
Re-injection (compiler/rustc_passes/src/dead.rs, `warn_multiple`): `chunk_by` now compares only `level_plus.0` (the Level), so several items with different expectation ids share one lint emitted on the first item only; the other expectations are never fulfilled (the bug the fix's loop addressed). The assert in `lint_at_single_level` (~line 1123) was relaxed to compare levels only so it does not ICE.
