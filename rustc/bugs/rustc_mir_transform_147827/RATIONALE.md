# Adapted injection for Fix MaybeUninit codegen using GVN

Fix: https://github.com/rust-lang/rust/commit/1a4852c5fe69219e145acc87ac35a8d21202101a

# Re-injection rationale
File: compiler/rustc_mir_transform/src/gvn.rs

1. `VnState::eval_to_const`, `Repeat` arm. Restored the old unconditional `Repeat(..) => return None`
   (re-expresses fix hunk `@@ -570,9 +570,19 @@ ... VnState`, which replaced it with an arm that evaluates
   `Repeat(value, _count)` to `ImmTy::uninit(ty)` when `value.is_immediate_uninit()`).
2. `op_to_prop_const`. Restored the old check that only Scalar/ScalarPair constants are synthesized
   (re-expresses fix hunk `@@ -1705,7 +1719,11 @@ fn op_to_prop_const`, which added `!op.is_immediate_uninit() &&`).

Not changed: the Union ZST hunk, and the codegen_ssa/pretty/operand.rs hunks (helper functions left in place; they are harmless).
