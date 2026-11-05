# Rationale
Only the executor and parser hunks of fix_impl.patch were reverted. The planner changes (winpathkeys and get_column_info_for_window) were left alone.

1. src/backend/executor/nodeWindowAgg.c, begin_partition(). This traces to the fix hunk that changes the framehead_ptr/frametail_ptr allocation.
   The old condition is restored. Read pointers are allocated only when ordNumCols != 0 and the frame end is not UNBOUNDED. With no ORDER BY, a RANGE/GROUPS frame with an OFFSET bound no longer gets its pointers. The frame-position code does still need them in that case.
2. src/backend/executor/nodeWindowAgg.c, ExecInitWindowAgg(). This traces to the fix hunk that changes framehead_slot/frametail_slot creation.
   The old `!UNBOUNDED_*` conditions are restored. They do not match what update_frameheadpos/update_frametailpos need. Slots are created for degenerate cases that don't need them, and some are missing where they are needed.
3. src/backend/parser/parse_clause.c, transformWindowDefinitions(). This traces to the fix hunk that adds the check.
   The "GROUPS mode requires an ORDER BY clause" error is removed again, so GROUPS without ORDER BY is accepted.

Failing oracle case: src/test/regress||window
