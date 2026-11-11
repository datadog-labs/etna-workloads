# Adapted injection for Ensure `yield` expressions desugar correctly in async generators

Fix: https://github.com/rust-lang/rust/commit/454bff768228e8dee53462ee63f766521191f8b0

# Hunk: compiler/rustc_ast_lowering/src/expr.rs, `lower_expr_yield`
Fix hunk `@@ -1635,19 +1634,32 @@` : the fix made `yield $expr` in async gen lower to
`task_context = yield async_gen_ready($expr)` (so the yield expr has type `()`).
Re-injected the old behaviour: `yielded` is wrapped in `async_gen_ready(..)` and the result is
returned as plain `hir::ExprKind::Yield(yielded, YieldSource::Yield)` with no `Assign` to `_task_context`,
so the yield expression's type is the resume type rather than `()`.
(The other two fix hunks, about `await` unreachable!, are unrelated to the bug and not re-injected.)
