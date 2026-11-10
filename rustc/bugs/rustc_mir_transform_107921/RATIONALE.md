# Adapted injection for Remove overflow checks from ConstProp.

Fix: https://github.com/rust-lang/rust/commit/e34caaf42dd10b3cb8d14e6e99c2c8687fe6342e

# Rationale
`compiler/rustc_mir_transform/src/const_prop.rs` no longer exists in 1.99.1; only DataflowConstProp remains.
One hunk, in `dataflow_const_prop.rs`, `handle_assign` (the `Rvalue::BinaryOp(op, ..) if op.is_overflowing()` arm).
It re-expresses fix hunk `@@ -180,12 +180,7 @@ impl<'tcx> ValueAnalysis<'tcx> for ConstAnalysis`, which replaced
`if overflow { FlatSet::Top /* Overflow cannot be reliably propagated */ } else { false }` with the direct overflow value.
The injected code maps an overflow flag known to be `true` to `FlatSet::Top` before it is stored.
