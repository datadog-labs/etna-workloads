# Adapted injection for Encode coroutine-closures in SMIR

Fix: https://github.com/rust-lang/rust/commit/91e74edca01dbbbb444117f9e85ed76164390314

One hunk: compiler/rustc_public/src/unstable/convert/stable/mir.rs, `impl Stable for mir::AggregateKind`.
Re-expresses fix hunk `@@ -565,8 +565,11 @@ impl<'tcx> Stable<'tcx> for mir::AggregateKind<'tcx>` in rustc_smir convert/mir.rs:
restores `mir::AggregateKind::CoroutineClosure(..) => { todo!("FIXME(async_closures): Lower these to SMIR") }`
instead of lowering to `AggregateKind::CoroutineClosure(tables.coroutine_closure_def(..), args.stable(..))`.
Other hunks of the fix (type additions) are already used elsewhere in 1.99.1; this one is the behavioural core.
