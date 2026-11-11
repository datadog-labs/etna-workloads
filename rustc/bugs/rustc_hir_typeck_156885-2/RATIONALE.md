# Adapted injection for Fix misattributed type inference error span for index expressions

Fix: https://github.com/rust-lang/rust/commit/d061dcb71f45ade7f38578edbbcbe486349037e8

# Rationale
In 1.99.1 the fix is expressed differently from upstream: `CastCheck::check` in compiler/rustc_hir_typeck/src/cast.rs
used a helper `expr_span_for_type_resolution` (and `index_operand_ambiguity_span`) to point the inference error at the
index operand (`.into()`), equivalent to the fix hunk `@@ -727,7 +727,21 @@ ... pub(crate) fn check` which resolved the
index type first with `fcx.structurally_resolve_type(idx.span, idx_ty)`.
I removed both helpers and restored `self.expr_ty = fcx.structurally_resolve_type(self.expr_span, self.expr_ty);`
(the pre-fix line removed by that hunk), so the error is attributed to the whole cast operand again.
The op.rs hunk (`@@ -313,6 +313,16 @@`) has no direct counterpart in 1.99.1 and was not re-expressed.
