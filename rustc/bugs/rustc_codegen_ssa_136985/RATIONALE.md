# Adapted injection for Add test that uninhabited repr(transparent) type has same function return ABI as wrapped type.

Fix: https://github.com/rust-lang/rust/commit/58ebf6afdd01d32f9f6d22d2e788c0dc10bc65a5

# Rationale
File: compiler/rustc_codegen_ssa/src/mir/block.rs, `codegen_call_terminator` (CallKind::Normal arm).
Re-expresses fix hunk `@@ -998,19 +995,12 @@`: the fix calls `make_return_dest` unconditionally ("We still need to call `make_return_dest` even if there's no `target`") and then `target.map(|target| (return_dest, target))`.
Buggy version restored: `make_return_dest` is only called inside `target.map(...)`, so for diverging calls with an uninhabited PassMode::Indirect return, the sret pointer is never pushed to `llargs`, and the call is missing its return-place argument.
(Only this call site is changed; the rest of the fix's hunks are the `target` parameter plumbing, which is unnecessary for the behaviour.)
