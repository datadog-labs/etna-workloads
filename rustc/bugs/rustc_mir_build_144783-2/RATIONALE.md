# Adapted injection for fix `#[loop_match]` on diverging loop

Fix: https://github.com/rust-lang/rust/commit/9916ce362f712b7aa91cd7576a5dcfc575ffd621

Hunk: compiler/rustc_mir_build/src/builder/expr/into.rs, `ExprKind::LoopMatch` lowering in `expr_into_dest`.
Fix hunk `@@ -345,7 +345,7 @@` changed `lower_match_arms(destination, ...)` -> `state_place`.
In 1.99.1 the code was restructured (arm results go to a temp `state_result_place`, then are copied into `state_place`),
so the equivalent bug is passing the loop's `destination` to `lower_match_arms` instead of `state_result_place`.
Arm results are then written to the loop's destination (wrong type/diverging), producing invalid MIR.
