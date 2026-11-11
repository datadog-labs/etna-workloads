# Adapted injection for Tweak await span

Fix: https://github.com/rust-lang/rust/commit/f0fc4f9acf19c2d35406688ff39106e90edfa979

# Hunk: compiler/rustc_ast_lowering/src/expr.rs, `lower_expr` ExprKind::Await arm
Re-expresses fix hunk `@@ -185,20 +185,14 @@ ... ExprKind::Await(expr) => {` (fix replaced the computed
`dot_await_span` (whitespace-extended end of `expr` to `e.span.hi()`) with the parser-recorded
`await_kw_span`). Reverted: the lowering ignores the stored keyword span and recomputes the `.await` span
from `expr.span` to `e.span.hi()`, so the await desugaring span again includes the leading `.`/whitespace.
