# Adapted injection for Remove `thir::Guard`

Fix: https://github.com/rust-lang/rust/commit/a549711f6e3dc804783652810a40653719dd0af7

# Rationale
File: compiler/rustc_mir_build/src/builder/matches/mod.rs, fn `declare_guard_bindings`.
Removed the `ExprKind::LogicalOp { op: LogicalOp::And, lhs, rhs }` arm, so `let` bindings inside let-chain guards
(`if let x = 42 && true`) are no longer declared per-arm (once for or-patterns).
Re-expresses fix hunk `@@ -745,7 +745,7 @@ ... declare_bindings`: `if let Some(&Guard::If(guard_expr)) = guard` -> `if let Some(guard_expr) = guard`,
i.e. the old code only declared guard bindings for the `Guard::If` form (guards with let chains were treated as plain
exprs, not handled the same as `if let` guards, which used a separate `Guard::IfLet` path). Here that unification is undone by
making let-chain guards lose binding declaration. Approximation: Guard enum no longer exists in 1.99.1.
