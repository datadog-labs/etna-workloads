# Rationale

All hunks are in `src/backend/optimizer/util/relnode.c`, function `build_joinrel_tlist()`. They trace to the fix.patch hunk that rewrote the nullingrel marking logic in the same function.

1. PHV branch and Var branch, `sjinfo->ojrelid` marking:
   - The fix replaced `!bms_overlap(nullingrels, commute_above_l)` with a check on whether the Var or PHV comes from syn_righthand (or syn_lefthand for FULL joins).
   - The bug is restored by going back to `!bms_overlap(..nullingrels, sjinfo->commute_above_l)`.
2. PHV branch and Var branch, `commute_above_r` marking:
   - The fix added only the members that are already in joinrel->relids.
   - The bug is restored by adding all of `commute_above_r` unconditionally (`bms_add_members`).
   - The nullingrel bits are then added prematurely.

Oracle cases expected to fail: src/test/regress||join
