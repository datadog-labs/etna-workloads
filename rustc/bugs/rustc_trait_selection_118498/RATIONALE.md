# Adapted injection for fix an ICE when a valtree failed to evaluate

Fix: https://github.com/rust-lang/rust/commit/1d120e61696b3be4a5695606e0b71d5b48c9e87d

# Rationale
File: compiler/rustc_trait_selection/src/traits/mod.rs, fn evaluate_const (the `Ok(Err(_))` arm after `tcx.const_eval_resolve_for_typeck`).
Fix hunk: `@@ -304,8 +304,16 @@ impl<'tcx> Const<'tcx>` in rustc_middle/src/ty/consts.rs, which replaced
`c.expect("`ty::Const::eval` called on a non-valtree-compatible type")` with a `let Some(c) = ... else { span_delayed_bug; return Err }`.
In 1.99.1 `Const::eval` no longer has that code; the equivalent is this arm, which emitted a delayed bug and returned
`InvalidConstParamTy`. I restored the pre-fix behaviour: a hard panic with the old expect message.
