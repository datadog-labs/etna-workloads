# Adapted injection for Emit error instead of delayed bug when meeting mismatch type for const tuple

Fix: https://github.com/rust-lang/rust/commit/9e0a27cfa9a35e35a9065a2802a9b1620639845d

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `lower_const_arg_tup`.
Re-expresses the fix hunk `@@ -2502,11 +2502,12 @@`: the fix replaced
`return Const::new_error_with_message(tcx, span, "const tuple must have a tuple type");`
with `tcx.dcx().span_err(span, "expected {}, found const tuple")` + `Const::new_error`.
In 1.99.1 the non-tuple arm emits a real error; I reverted it to the delayed-bug `new_error_with_message(..., "const tuple must have a tuple type")` (ICE-style delayed bug, no user-facing error).
