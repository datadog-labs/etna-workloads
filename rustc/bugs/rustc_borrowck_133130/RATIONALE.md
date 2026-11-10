# Adapted injection for `suggest_borrow_generic_arg`: instantiate clauses properly

Fix: https://github.com/rust-lang/rust/commit/546ba3d310ae2d795b43188ce1b9980b33e690e5

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, fn `suggest_borrow_generic_arg`.

One hunk (re-expresses fix hunks 2 and 3, `@@ -649,11 +649,11 @@` and `@@ -700,23 +700,17 @@`).
The fix replaced the old "substitute `ref_ty` as self type only for bounds on `param`, then instantiate with
`generic_args`" check with `clauses.instantiate(tcx, new_args)` (+ normalization). I restored the old logic:
iterate `clauses.instantiate_identity(tcx).clauses`, rewrite Trait/Projection clauses whose self ty is `param`
using `with_replaced_self_ty(tcx, ref_ty)` (the current name of the old `with_self_ty`), then
`EarlyBinder::bind(..).instantiate(tcx, generic_args)`. Bug: region vars in the moved type (via generic_args) leak
into the predicate check, so the suggestion is wrongly dropped (#133118); bounds like `Borrow<T>` are also checked incorrectly.
Hunk 1 (import of ClauseKind) is unnecessary since I use `ty::ClauseKind`.
