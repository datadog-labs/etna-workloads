# Adapted injection for FIx ICE while casting a type with error

Fix: https://github.com/rust-lang/rust/commit/fb619ec208b898bad1505c97ee79408b2c60926b

# Rationale
Fix hunk: `@@ -140,7 +140,10 @@ cast.rs` in `pointer_kind`: `span_bug(...)` replaced by `span_delayed_bug(...)` + `return Err(guar)`.
In 1.99.1 that hunk is already present; later code added guards so error types never reach it. To bring the ICE back:
1. cast.rs `pointer_kind`: restored `self.dcx().span_bug(span, "`{t:?}` should be sized but is not?")` in the Error/Adt/... arm (direct reversal of the fix hunk), and removed the later `t.error_reported()?` early return.
2. cast.rs `CastCheck::check`: removed the `else if self.expr_ty.references_error() || self.cast_ty.references_error()` skip branch so error-containing casts reach pointer_kind.
3. expr.rs `check_expr_cast`: removed the eager `(t_expr, t_cast).error_reported()` bail-out, so the cast is deferred even with error types.
Hunks 2-3 are the guards that mask the fixed behaviour; they are not literal fix hunks but are needed for the span_bug to be reachable.
