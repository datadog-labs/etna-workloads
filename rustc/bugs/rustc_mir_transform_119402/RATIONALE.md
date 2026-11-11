# Adapted injection for Also walk bindings created by if-let guards

Fix: https://github.com/rust-lang/rust/commit/ab60a7df6446bf175b9717ff4e96288287393c02

# Rationale
File: compiler/rustc_mir_transform/src/liveness.rs (unused-variable liveness moved from rustc_passes/liveness.rs to MIR).

The fix hunk `@@ -1351,6 +1351,9 @@ fn visit_arm` added
`if let Some(hir::Guard::IfLet(let_expr)) = arm.guard { self.check_unused_vars_in_pat(let_expr.pat, ...) }`
so bindings created by if-let guards are also checked. In 1.99.1 there is no HIR arm walk; the analogue is
`report_fully_unused`. I added helper `is_in_if_let_guard_pat` (HIR visitor over arms, checking `ExprKind::Let` guard pattern spans) and
skip any local whose def_span lies in an if-let guard pattern, so those bindings are not reported (old behaviour).
