# Adapted injection for Don't leak unnameable types in -> _ recover

Fix: https://github.com/rust-lang/rust/commit/b09c17774399bc93ba098cd05cb6c57155f8360b

# Rationale
File: compiler/rustc_hir_analysis/src/collect.rs, fn `infer_return_ty_for_fn_sig` (final fn sig construction).
Re-expresses fix hunk `@@ -1404,18 +1404,13 @@ fn infer_return_ty_for_fn_sig`: the fix returns `recovered_ret_ty.unwrap_or_else(|| Ty::new_error(tcx, guar))` (the suggestable, nameable type) in the new sig. I restored the old behaviour: when recovery happens, the raw `ret_ty` (which may be an unnameable FnDef/closure/coroutine) leaks into the sig; otherwise error type.
The variance/constraints.rs hunk only changed a bug! message, not reinjected.
