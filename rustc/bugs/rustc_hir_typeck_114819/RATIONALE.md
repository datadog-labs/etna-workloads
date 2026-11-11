# Adapted injection for Point at return type when it influences non-first `match` arm

Fix: https://github.com/rust-lang/rust/commit/55f8c66a601236b422e35f56f7e414a8280c78d4

# Rationale
One hunk: compiler/rustc_hir_typeck/src/_match.rs, `check_match`. In the fix hunk
(`-            prior_arm = Some((arm_block_id, arm_ty, arm_span));` / `+            if !arm_ty.is_never() { prior_arm = Some(...) }`)
`prior_arm` is only updated for non-`!` arms. In 1.99.1 that guard already wraps both `prior_arm` and `prior_non_diverging_arms`; I moved `prior_arm = Some(..)` out of the guard so diverging arms (e.g. `return 0`) again count as the prior arm, and later arms point at them instead of the return type.
The other fix hunks (extra BlockTailExpression fields) were already refactored upstream (now `BlockTailExpression(hir_id, match_src)`) and are not needed for the behaviour.
