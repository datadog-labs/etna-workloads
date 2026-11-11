# Adapted injection for Remove wrong assertion.

Fix: https://github.com/rust-lang/rust/commit/84cb7ecbc1a54de37422a0bf3cc68987acb6610b

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, fn `visit_land_rhs`.
Added arm `ExprKind::LogicalOp { op: LogicalOp::And, .. } => { bug!() }`.
The fix hunk `@@ -334,9 +334,6 @@` removed exactly this wrong assertion (`-ExprKind::LogicalOp { op: LogicalOp::And, .. } => { bug!() }`) from the rhs-visiting match (now `visit_land_rhs`). A parenthesized `&&` on the rhs of `&&` in a guard now ICEs.
