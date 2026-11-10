# Adapted injection for Fix missing unused_variables lint when using a match guard

Fix: https://github.com/rust-lang/rust/commit/5aba6b1635935237a146d759e67bc7d3e8bdc73b

# Rationale
compiler/rustc_mir_transform/src/liveness.rs, `TransferFunction::visit_statement`: restored the pre-fix match arm so only `FakeReadCause::ForLet(None)` is skipped; `ForGuardBinding` fake reads are again treated as real reads, marking guard-bound locals live.
Re-expresses fix hunk `@@ -1243,9 +1243,12 @@ struct TransferFunction` (`ForLet(None) | ForGuardBinding` -> `ForLet(None)`).
