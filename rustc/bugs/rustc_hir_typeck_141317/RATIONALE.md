# Adapted injection for typeck: catch `continue`s pointing to blocks

Fix: https://github.com/rust-lang/rust/commit/ed01a205144f53741534611a74d40487f611cdea

# Hunk: compiler/rustc_hir_typeck/src/expr.rs, `check_expr_continue`
Re-expresses fix hunk `@@ -532,14 +532,7 @@ ... ExprKind::Continue(destination)`: the fix added a check that the `continue` target is a `Loop`, else taints typeck with an error. I removed the check, so any resolved target gives `never` (the old behaviour), and a `continue` to a labeled block no longer taints typeck.
Not re-expressed: the liveness.rs hunks (ErrNode / assertion) since liveness.rs moved/no longer exists in this form; mir_build comment hunk is comment only.
