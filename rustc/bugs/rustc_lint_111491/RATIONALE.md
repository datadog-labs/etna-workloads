# Adapted injection for Dont check `must_use` on nested `impl Future` from fn

Fix: https://github.com/rust-lang/rust/commit/926e874fd1dccc208bf63db7a4288adf46caa3c3

# Rationale
File: compiler/rustc_lint/src/unused/must_use.rs (was unused.rs), `UnusedResults::check_stmt` (the `.await` handling).
Fix hunk `@@ -103,8 +103,10 @@ impl<'tcx> LateLintPass<'tcx> for UnusedResults` added
`&& matches!(cx.tcx.def_kind(async_fn_def_id), DefKind::Fn | DefKind::AssocFn)` and
`&& cx.tcx.asyncness(async_fn_def_id).is_async()`, replacing the FIXME comment. I removed both conditions and restored the FIXME,
so `must_use` is checked on the parent of any opaque future, including non-async fns returning `impl Future` (and nested opaques).
