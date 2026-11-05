# Rationale

Hunk: src/backend/utils/adt/tsvector_op.c, checkcondition_str() (prefix-search tail).

Traces to the fix.patch hunk that added `res = (npos > 0)` ("at loop exit, res must be true if we found matches"). In today's code the equivalent is `res = TS_YES;` after the positions of prefix matches are merged (`if (data && npos > 0)`). I removed that line. With position data requested (phrase search), prefix matches are found and data->pos is filled, but the function still returns TS_NO (set before the loop). So phrase queries with prefix operands wrongly fail to match.

Oracle cases expected to fail: src/test/regress||tstypes
