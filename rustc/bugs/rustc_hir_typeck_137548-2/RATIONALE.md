# Adapted injection for Properly support thin ptrs that are only thin due to their param-env in asm macro

Fix: https://github.com/rust-lang/rust/commit/04c00585c36e6e74dbe998d7c3b190955f757469

In 1.99.1 InlineAsmCtxt lives in compiler/rustc_hir_typeck/src/inline_asm.rs and holds `fcx`, so the fix's `typing_env` parameter became `fcx.param_env`.
Hunk changed: `InlineAsmCtxt::is_thin_ptr_ty` now calls `type_is_sized_modulo_regions(ty::ParamEnv::empty(), ty)` instead of `self.fcx.param_env`.
This re-expresses fix.diff's intrinsicck.rs hunk `@@ -33,14 +33,12 @@ InlineAsmCtxt::new`. That hunk replaced the hard-coded `param_env: ty::ParamEnv::empty()` with the caller's typing_env (checks.rs passes `self.typing_env(self.param_env)`).
With the empty env, `*mut T` is not seen as thin when `T: ?Sized` is only resolved through the where-clauses, so the asm check rejects it.
