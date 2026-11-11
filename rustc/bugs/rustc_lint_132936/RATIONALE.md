# Adapted injection for For expr `return (_ = 42);` unused_paren lint should not be triggered

Fix: https://github.com/rust-lang/rust/commit/33d3c27d38df5af198ecb9ace7546cab37818dc5

compiler/rustc_lint/src/unused.rs, `UnusedDelimLint::check_unused_delims_expr` (UnusedParens impl): the guard `!((ctx == ReturnValue || ctx == BreakValue) && matches!(inner.kind, Assign(..)))` was reduced to only `BreakValue`. This re-expresses the fix hunk `@@ -1063,6 +1063,8 @@` which added `&& !(ctx == UnusedDelimsCtx::ReturnValue && matches!(inner.kind, ast::ExprKind::Assign(_, _, _)))`. So `return (_ = 42);` warns unused_parens again.
