# Rationale

The fix (amatch.c) added `amatchTruncateInt()` and used it in three places. All three hunks are reversed in `tree/ext/misc/amatch.c`; the code in 3.54.1 matched the post-fix code, so the reversal is direct.

- `amatchTruncateInt` helper removed (fix hunk 1; it has no remaining callers).
- `amatchLoadOneRule`: cost is read again with `sqlite3_column_int(pStmt, 3)` instead of `column_int64` plus truncation (hunk 2). A 64-bit value is now wrapped to 32 bits instead of being clamped.
- `amatchFilter`: `rLimit` and `iLang` are read with `sqlite3_value_int()` again instead of `value_int64` plus truncation (hunk 3).

## Oracle failure
`amatch1-5.2` fails (expected `abc 0`, got empty). The constraint `distance<9223372036854775807` is converted with `sqlite3_value_int`, which wraps to -1, so the limit excludes every row. Clamping to INT_MAX was the fix.
