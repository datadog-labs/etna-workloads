# Adapted injection for check array type of repeat exprs is wf

Fix: https://github.com/rust-lang/rust/commit/c04106f9f13cb6e8f73aff8ea0888e94631dc47a

# Rationale
1. compiler/rustc_hir_typeck/src/expr.rs, check_expr_repeat: removed `self.register_wf_obligation(array_ty, expr.span, WellFormed(None))` for the repeat-expression array type. Re-expresses fix hunk `@@ -1426,6 +1426,12 @@ ... check_repeat_element_needs_copy_bound` (adds register_wf_obligation(mk_array_with_const_len(t,count))).
2. compiler/rustc_borrowck/src/type_check/mod.rs, check_rvalue `Rvalue::Repeat`: removed `prove_clause(WellFormed(array_ty))`. Re-expresses hunk `@@ -1803,6 +1803,13 @@` (`let array_ty = rvalue.ty(..); self.prove_predicate(WellFormed(array_ty.into()) ...)`).
The visitor/renumber hunks (visit_ty_const) were not reverted (support code only).
