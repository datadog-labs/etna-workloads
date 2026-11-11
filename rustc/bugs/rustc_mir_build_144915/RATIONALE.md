# Adapted injection for Defer tail call ret ty equality to check_tail_calls

Fix: https://github.com/rust-lang/rust/commit/6a088fd5847b1b24733011fcaab87dfc49853eec

# Rationale
File: compiler/rustc_mir_build/src/check_tail_calls.rs, fn check_tail_call (signature comparison).
Re-expresses fix hunk `@@ -135,30 +135,23 @@ impl<'tcx> TailCallCkVisitor`: the fix replaced the split
"inputs mismatch -> report; output mismatch -> span_bug!(hir typeck should have checked the return type already)"
with a single `report_signature_mismatch` on any `inputs_and_output` difference. I restored the split, so
output-only mismatches (e.g. `for<'a> fn(&'a i32)` vs `fn(&'static i32)`) ICE instead of a "mismatched signatures" error.
(The fn-rename hunk and the borrowck message hunk are cosmetic and were not reverted.)
