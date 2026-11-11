# Adapted injection for codegen: add OperandValue::Uninit to skip stores for entirely-uninit constants

Fix: https://github.com/rust-lang/rust/commit/ed9de1e4663c73242710235ff343895e16a4d539

# Rationale
1.99.1 already had per-site `is_entirely_uninit_const` checks (no `OperandValue::Uninit`).
Changed: `compiler/rustc_codegen_ssa/src/mir/rvalue.rs`, `codegen_rvalue`, `Rvalue::Aggregate` arm:
removed the loop's `if self.is_entirely_uninit_const(operand) { continue; }` skip.
Re-expresses the fix's behaviour (`store_with_flags` no-op for `OperandValue::Uninit` applying uniformly,
incl. aggregate fields; fix hunk `@@ rvalue.rs -194,25 +191,12` / `OperandValue::Uninit => {}` in operand.rs store).
Without it, uninit const fields of aggregates are memcpy'd from an undef global (issue #157743).
