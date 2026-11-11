# Adapted injection for Avoid loop_match self-assignment in MIR lowering

Fix: https://github.com/rust-lang/rust/commit/c5f8952bb3022a7a76293a47940d1bf7f417d27a

# Rationale
Only hunk: compiler/rustc_mir_build/src/builder/expr/into.rs, `ExprKind::LoopMatch` lowering in `expr_into_dest`.

In 1.99.1 the fix's idea (don't emit `state = state`; go through a temp) lives here rather than in the
`@@ -812,7 +812,19 @@` VarRef hunk (`let temp = this.temp(...)` / `places_conflict_for_assignment(destination, place)`),
which doesn't exist at that spot any more (lint.rs already has the helper). I removed the `state_result` temporary:
the breakable scope and `lower_match_arms` write directly to `state_place` again and the trailing
`state_place = copy state_result_place` push_assign is gone. So `break 'blk state` lowers to the
self-assignment `_1 = copy _1`, which violates MIR's non-overlap rule (ICE under -Zlint-mir, issue 143806).
