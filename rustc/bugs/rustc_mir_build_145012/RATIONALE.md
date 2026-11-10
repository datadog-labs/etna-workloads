# Adapted injection for fixed diagnostic

Fix: https://github.com/rust-lang/rust/commit/51df1dad6c7465395a8ac3e6c31b04468ba347b4

# Rationale
File compiler/rustc_mir_build/src/check_tail_calls.rs, fn check_tail_call (signature-mismatch branch).
Fix hunk `@@ -132,7 +133,15 @@ impl<'tcx> TailCallCkVisitor<'_, 'tcx>` replaced `self.report_arguments_mismatch(expr.span, caller_sig, callee_sig)`
with liberate_late_bound_regions(CRATE_DEF_ID, fn_sig) of the caller/callee types (so lifetimes appear in diagnostics).
On 1.99.1 the equivalent code is the `report_signature_mismatch(expr.span, liberate..., liberate...)` call; I restored the
parent behaviour: pass the region-erased `caller_sig`/`callee_sig`, so lifetimes vanish from the note. Also removed the now-unused CRATE_DEF_ID import (fix hunk #1).
