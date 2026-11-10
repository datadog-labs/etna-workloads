# Adapted injection for Use more principled check for generics in const ops

Fix: https://github.com/rust-lang/rust/commit/c7e368543c2728c76a41008577b64b0ede7f708e

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn lower_path (Res::SelfTyParam / Res::SelfTyAlias arms).
The 1.99.1 tree already contains the fix. Two call sites of `check_param_uses_if_mcg` are removed, so MCG anon consts no longer reject `Self`:
- `Res::SelfTyParam`: `self.check_param_uses_if_mcg(tcx.types.self_param, span, false)` -> `tcx.types.self_param`
  (fix hunk `@@ -2032,9 +2147,9 @@`, `-tcx.types.self_param` / `+self.check_param_uses_if_mcg(tcx.types.self_param, span, false)`).
- `Res::SelfTyAlias`: `self.check_param_uses_if_mcg(ty, span, true)` -> `ty` (same hunk; the fix replaced the old `forbid_generic && ty.has_param()` hack with this call).
Result: generic `Self` / `Self` aliases are no longer rejected in MCG anon consts, so the diagnostics go missing or ICEs return.
