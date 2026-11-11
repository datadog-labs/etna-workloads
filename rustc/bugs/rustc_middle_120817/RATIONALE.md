# Adapted injection for Don't ICE in ByMoveBody when coroutine is tainted

Fix: https://github.com/rust-lang/rust/commit/698a3c7adeed1213e1c3af73158566a85795a3c2

# Re-injection of #120817 ("Don't ICE in ByMoveBody when coroutine is tainted") into 1.99.1

Pre-fix behaviour: the by-move-body logic ran on every async-closure coroutine. That included
coroutines whose MIR/type was error-tainted, and in that case it hit
`let ty::Coroutine(..) = coroutine_ty.kind() else { bug!() }`. Separately, `construct_error` built a
fake signature for `CoroutineClosure` bodies made entirely of error types.

## Hunk 1: compiler/rustc_mir_transform/src/coroutine/by_move_body.rs, `coroutine_by_move_body_def_id`
Removed the early return `if body.tainted_by_errors.is_some() { return coroutine_def_id.to_def_id(); }`.
This is today's version of the guard the fix added (the pass is now a query, and the
`references_error` check became a tainted-body check; the leftover comment "Also, let's skip processing
any bodies with errors" comes from the fix). Without it, an errored coroutine body reaches the
`bug!("tried to create by-move body of non-coroutine receiver")`.
Re-expresses fix hunk `@@ -23,7 +23,10 @@ impl<'tcx> MirPass<'tcx> for ByMoveBody {`:
```
-        let ty::Coroutine(_, args) = *coroutine_ty.kind() else { bug!() };
+        if coroutine_ty.references_error() {
+            return;
+        }
+        let ty::Coroutine(_, args) = *coroutine_ty.kind() else { bug!("{body:#?}") };
```
(The `TypeVisitableExt` import hunk `@@ -7,7 +7,7 @@` has no counterpart to revert. The import is still used by
`parent_args.references_error()`.)

## Hunk 2: compiler/rustc_middle/src/ty/context.rs, `TyCtxt::needs_coroutine_by_move_body_def_id`
In 1.99.1 the by-move query only runs if this predicate holds. The predicate requires
`type_of(coroutine)` to be `ty::Coroutine`, so a coroutine whose type is `{type error}` is skipped
before it reaches the query. That is a second place where the fix's "skip error-typed coroutines" check
now lives. Pre-fix, the pass's only gate was `coroutine_kind == Desugared(_, Closure)`, with no check on
the type. I changed the predicate so that a non-`Coroutine` (error) type still counts as needing a
by-move body; the FnOnce filter only applies when the type is known. This trace is to the same fix hunk
as above (`@@ -23,7 +23,10 @@`, the `if coroutine_ty.references_error() { return; }` guard).

## Hunk 3: compiler/rustc_mir_build/src/builder/mod.rs, `construct_error`, `ty::CoroutineClosure` arm
Restored the pre-fix error signature: the inputs come from `closure_user_provided_sig`, and every input
and the return type are `Ty::new_error`. The fix had replaced this with the real self type, the tupled
inputs and a `to_coroutine(...)` return type.
Re-expresses fix hunk `@@ -675,16 +675,32 @@ fn construct_error(tcx: TyCtxt<'_>, def_id: LocalDefId, guar: ErrorGuaranteed) -`:
```
-                ty::CoroutineClosure(did, _args) => {
-                    // FIXME(async_closures): Recover the proper error signature
-                    let inputs = tcx
-                        .closure_user_provided_sig(did.expect_local())
...
-                    (inputs.iter().map(|_| err).collect(), err, None)
+                ty::CoroutineClosure(did, args) => {
+                    let args = args.as_coroutine_closure();
...
```
