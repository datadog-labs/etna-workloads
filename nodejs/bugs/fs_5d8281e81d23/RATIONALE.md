# Re-introduced bug: fs stat data uses unsigned types (nodejs#43707)

Bug: stat data was stored in unsigned arrays (BigUint64Array for bigint stats) and times were cast to `unsigned long`, so timestamps before 1970-01-01 (negative tv_sec) were wrapped to huge values. `dateFromMs` also used `new Date(ms + 0.5)` instead of rounding, which is wrong for negatives.

Hunks (each is the reverse of a fix hunk, adapted to today's code):
- `src/node_file.h`: `stats_field_bigint_array` back to `AliasedBigUint64Array` (fix: aliased BigUint64 -> BigInt64). The `statfs` array was not touched by the fix and is left alone.
- `src/node_file-inl.h` GetReqWrap: promise type back to `FSReqPromise<AliasedBigUint64Array>`.
- `src/node_file-inl.h` FillStatsArray: `SET_FIELD_WITH_TIME_STAT` always casts to `unsigned long`, dropping the non-Windows `double` variant.
- `lib/internal/fs/utils.js`: `isBigUint64Array` in `getStatsFromBinding` (matches the new array type), `dateFromMs` back to `new Date(Number(ms) + 0.5)`, and the unused `MathRound` import removed.

Failing test: `parallel/test-fs-stat-date` (not ok in two consecutive runs). Pre-1970 timestamps (`-40691`, `-1`) are wrapped to huge unsigned values; the test fails with `TypeError: Cannot mix BigInt and other types, use explicit conversions`.
