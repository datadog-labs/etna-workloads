# Adapted injection for fix #[expect(dead_code)] liveness propagation

Fix: https://github.com/rust-lang/rust/commit/faa7966a5bafb7e694e56126dd39ed8faf13d09d

# Rationale
Only file changed: compiler/rustc_passes/src/dead.rs, `MarkSymbolVisitor::check_def_id` and `insert_def_id`.
The WorkItem/propagated/own plumbing already exists in 1.99.1; the bug is in how the propagated context is used.
Re-expresses fix hunks `@@ -101,19 +137,45 @@ impl<'tcx> MarkSymbolVisitor<'tcx>` (check_def_id) and the following insert_def_id hunk:
- the fix pushes `WorkItem { propagated: self.propagated_comes_from_allow_expect, own: own_comes_from_allow_expect }`
  and only does `live_symbols.insert` when `own == No`; buggy parent pushed `(def_id, ComesFromAllowExpect::No)` and always inserted.
- Reverted: items reached from an `#[expect(dead_code)]` item are pushed with propagated=No/own=No and always marked live, so expectations on them go unfulfilled.
(`own_comes_from_allow_expect` is now unused -> a dead_code warning only.)
