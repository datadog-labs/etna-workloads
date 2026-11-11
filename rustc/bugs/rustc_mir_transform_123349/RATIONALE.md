# Adapted injection for Fix capture analysis for by-move closure bodies

Fix: https://github.com/rust-lang/rust/commit/a1a1f41027c16a940c1de9e445064692110637c8

# Rationale

File: compiler/rustc_mir_transform/src/coroutine/by_move_body.rs, fn `coroutine_by_move_body_def_id`.

Re-expresses the hunk `@@ -26,36 +28,68 @@ impl<'tcx> MirPass<'tcx> for ByMoveBody`. The fix replaced
```
let by_move_upvars = Ty::new_tup_from_iter(tcx, tcx.closure_captures(coroutine_def_id).iter().enumerate().map(|(idx, capture)| { ... capture.place.ty() }))
```
with `tupled_upvars_ty: args + parent_upvars_ty fields` (the parent closure's by-move upvars, with args first).
On 1.99.1 the equivalent is `to_coroutine_given_kind_and_upvars(..., parent_closure_args.tupled_upvars_ty(), ...)`.
I put back the old behaviour: the by-move coroutine's upvar tuple is built from the child coroutine's own
captures (`capture.place.ty()`), not the parent's upvars. The field remapping, which already points at parent
upvar fields, no longer matches the coroutine type, so the MIR is broken.
