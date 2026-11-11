# Adapted injection for Fix drop shim for AsyncFnOnce closure, AsyncFnMut shim for AsyncFn closure

Fix: https://github.com/rust-lang/rust/commit/ca444160232a1bf1914da906da9e061a7636955c

# Rationale
One hunk: compiler/rustc_mir_transform/src/shim.rs, `make_shim`, `ShimKind::DropGlue` arm for coroutines.
Re-expresses fix hunk `@@ -72,32 +72,70 @@ fn make_shim` (the DropGlue part): the fix added
`let ty::Coroutine(_, id_args) = ...` and chose `coroutine_by_move_body().coroutine_drop()` when the
coroutine's kind_ty differs from the def's kind_ty. Parent behaviour (restored): always use
`tcx.optimized_mir(coroutine_def_id).coroutine_drop()`, so the future from `AsyncFnOnce::call_once`
uses the by-ref body's drop glue and doesn't drop the closure's upvars (drop.rs fails).
