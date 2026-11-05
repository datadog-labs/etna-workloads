# Rationale

File: src/backend/utils/adt/jsonpath_exec.c

Hunks: `cmpDateToTimestamp`, `cmpDateToTimestampTz`, `cmpTimestampToTimestampTz`, and their call sites in `compareDatetime`.

Traces to the fix.patch jsonpath_exec.c hunks that replaced the `*_opt_error` casts (which set `have_error` on overflow) with `cmp*` helpers that handle overflow (`cmpTimestampWithOverflow`). Reversing that, the helpers once more cast with `date2timestamp_opt_overflow` / `date2timestamptz_opt_overflow` / `timestamp2timestamptz_opt_overflow`. If the cast overflows they set `*cast_error`, so the comparison returns jpbUnknown instead of a correct ordering. Out-of-range values (e.g. a date beyond the timestamp range, compared with a timestamp) therefore give unknown, where they should compare as lower or higher.

The date.c, timestamp.c and header function renames were not needed. Those functions already report the overflow direction in today's code.

Oracle case expected to fail: src/test/regress||jsonb_jsonpath
