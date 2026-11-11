# Adapted injection for review comments + more tests

Fix: https://github.com/rust-lang/rust/commit/6cf01fcf1ec24142919d92035b8531c4ff1deaca

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, in the `CandidateSource::Impl` arm of the multiple-candidates note code. This is the call to `print_disambiguation_help`.

I removed `.with_replaced_self_ty(self.tcx, rcvr_ty)` from the impl trait_ref. The suggestion for impl candidates then uses the impl's own self type (for example the blanket `T`) instead of the receiver type.

This re-expresses the fix hunk `@@ -1340,7 +1340,7 @@` and its sibling hunks, where `impl_ty` / `Some(impl_ty)` are passed as the impl self type. It also relates to `@@ -3148 ... print_disambiguation_help`, where the self type used in `<{self_ty} as {trait_name}>` came from the impl.

The code has been rewritten since the fix, so this is an approximation of the old behaviour, not a literal reversal. The fix's hunks don't apply to 1.99.1.
