# Adapted injection for Restore if let guard temporary scoping difference

Fix: https://github.com/rust-lang/rust/commit/1a267e3f40c4c6e32482a7dd98c512f4664a329e

# Rationale
File: compiler/rustc_hir_analysis/src/check/region.rs, fn `resolve_arm`.
Replaced `resolve_cond(visitor, guard)` with `resolve_expr(visitor, guard, true)`, so every match guard
(including `if let` / let-chain guards) is a terminating scope and its temporaries drop at the end of
the guard rather than living for the whole arm.
This re-expresses the fix hunk `@@ -184,8 +192,9 @@ fn resolve_arm` which added
`if let Some(expr) = arm.guard && !has_let_expr(expr)` around marking the guard terminating
(in 1.99.1 that logic lives in `resolve_cond`, which skips termination for `let` expressions).
The buggy parent terminated all guards unconditionally.
