# Adapted injection for Revert "Auto merge of #133734 - scottmcm:lower-indexing-to-ptrmetadata, r=davidtwco,RalfJung"

Fix: https://github.com/rust-lang/rust/commit/122a55bb442bd1995df9cf9b36e6f65ed3ef4a1d

# Rationale
Only one hunk: compiler/rustc_mir_transform/src/validate.rs, TypeChecker::visit_rvalue, `UnOp::PtrMetadata` arm.
Re-expresses fix hunk `@@ -1124,6 +1124,14 @@ ... UnOp::PtrMetadata => {` which (in the revert) adds
`if !matches!(self.body.phase, MirPhase::Runtime(_)) { self.fail(location, "PtrMetadata should be in runtime MIR only"); }`.
Other hunks (Rvalue::Len in bounds_check, simplify_len) can't be restored: Rvalue::Len no longer exists in 1.99.1.
Effect: PtrMetadata emitted by MIR building/early lowering fails MIR validation before runtime phase.
