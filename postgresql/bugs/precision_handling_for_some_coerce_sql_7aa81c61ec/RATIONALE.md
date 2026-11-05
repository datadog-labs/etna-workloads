# Rationale

The original functions (current_time(), sql_localtime(), current_timestamp(), sql_localtimestamp() in date.c/timestamp.c) no longer exist. CURRENT_TIME(n) and friends are now SQLValueFunction nodes, and the typmod check lives in `transformSQLValueFunction` (src/backend/parser/parse_expr.c).

## Changed hunk
- File/function: src/backend/parser/parse_expr.c, `transformSQLValueFunction`, cases CURRENT_TIME_N, CURRENT_TIMESTAMP_N, LOCALTIME_N and LOCALTIMESTAMP_N.
- Traces to: the date.c and timestamp.c hunks of fix.patch. They changed code that called `anytime(stamp)_typmod_check()` and discarded the result into one that assigns the result to typmod.
- Reintroduced bug: the checked (clamped) typmod is discarded again, so the raw out-of-range precision is kept after the WARNING. This is the same logic as the original bug. CURRENT_TIMESTAMP(7) and LOCALTIMESTAMP(7) then warn and still fail later, and the TIME variants keep a wrong precision.

## Failing oracle cases
- src/test/regress||expressions
