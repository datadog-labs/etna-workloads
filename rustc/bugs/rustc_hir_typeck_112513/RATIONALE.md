# Adapted injection for Don't suggest boxing an empty if/else arm

Fix: https://github.com/rust-lang/rust/commit/d80440263c3eb083a91335ab14bee76bcb9988d1

# Rationale
File: compiler/rustc_hir_typeck/src/coercion.rs, fn report_mismatched_types path, `ObligationCauseCode::IfExpression { tail_defines_return_position_impl_trait: Some(..) }` arm.

The fix hunk (`@@ -847,7 +847,25 @@ impl<'tcx> TypeErrCtxt`, adding `is_empty_arm(then_id)`/`is_empty_arm(else_id)` to
`if let Some(ret_sp) = opt_suggest_box_span && !is_empty_arm(then_id) && !is_empty_arm(else_id)`)
lived in rustc_infer; in 1.99.1 the boxing suggestion moved here and the guard is
`then_span != then_expr.span && else_span != else_expr.span`, which suppresses the suggestion for empty blocks
(an empty block's span equals the expr span). I re-introduce the bug by treating empty blocks as exempt from that
guard (`|| is_empty_block(..)`), so the "box" suggestion is emitted for an empty else arm again.
