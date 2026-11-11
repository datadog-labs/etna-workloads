# Adapted injection for Anonymize binders in tail call sig

Fix: https://github.com/rust-lang/rust/commit/f6ce4ac9d38fca2df5bc408de8f4c2567d2f2709

File: compiler/rustc_mir_build/src/check_tail_calls.rs, fn check_tail_call (TailCallCkVisitor).
Removed `let caller_sig = self.tcx.erase_and_anonymize_regions(caller_sig);` (and its comment).
Re-expresses fix hunk `@@ -60,9 +60,13 @@` which added `let caller_sig = self.tcx.erase_regions(caller_sig);` (renamed to erase_and_anonymize_regions in 1.99.1). Without it, binders in fn-pointer args are not anonymized and caller/callee sigs mismatch.
