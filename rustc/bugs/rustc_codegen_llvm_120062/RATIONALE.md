# Adapted injection for llvm: simplify data layout check

Fix: https://github.com/rust-lang/rust/commit/46652dd254bc9c413d14cec637c7f21ac6601e05

# Rationale
File compiler/rustc_codegen_llvm/src/context.rs, `create_module`: the data-layout consistency check is wrapped in `if matches!(sess.opts.target_triple, TargetTuple::TargetTuple(_))` (i.e. builtin targets only; `Target::is_builtin` no longer exists in 1.99.1).
Re-expresses fix hunk `@@ -147,8 +148,7 @@ create_module`: `-    if sess.target.is_builtin {` / `+    {`. Non-builtin (JSON) targets with mismatched data layouts skip the check again, so no MismatchedDataLayout error is emitted.
(The CFG_LLVM_ROOT hunks can't be restored: bootstrap no longer sets it, and the error type/ftl already exist.)
