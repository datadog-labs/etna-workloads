# Adapted injection for fix inference variables leaking into HIR const lowering logic

Fix: https://github.com/rust-lang/rust/commit/11810b8dd9d5ea1dad36eb5f6c77fa5d95871a81

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `lower_const_arg_literal`.
Re-expresses the fix hunk `@@ -2874,6 +2874,12 @@` which added `if ty.has_infer() { span_err("inference variables are not supported in constants"); return error const }`.
In 1.99.1 the guard had become `let ty = if !ty.has_infer() { Some(ty) } else { None };` (inference-var types are dropped so lit_to_const reports "type annotations needed for the literal"). The bug is reintroduced by `let ty = Some(ty);`, so inference variables leak into lit_to_const (ICE at const_kind.rs:184).
