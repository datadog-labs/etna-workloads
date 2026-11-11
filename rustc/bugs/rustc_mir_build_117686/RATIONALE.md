# Adapted injection for Build pre-coroutine-transform coroutine body

Fix: https://github.com/rust-lang/rust/commit/0ba7d19769c068729761eba72e779b53101a19bc

# Rationale
compiler/rustc_mir_build/src/builder/mod.rs, `construct_error`, `ty::Coroutine` arm (file was build/mod.rs upstream).
Re-expresses fix hunk `@@ -656,17 +656,7 @@ fn construct_error`: the fix replaced the post-transform signature
(Pin<&mut coroutine> self, CoroutineState<yield, return> output) with `(vec![coroutine_ty, args.resume_ty()], return_ty, Some(yield_ty))`.
I restored the old Pin<&mut C> input and CoroutineState output for the error body.
