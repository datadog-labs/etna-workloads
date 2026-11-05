# Rationale

File/function: src/backend/commands/copyfromparse.c, CopyReadLineText (all hunks trace to the copyfromparse.c hunks of fix.patch, reversed).

- Re-added `first_char_in_line` variable (set false at the end of each loop iteration) -> fix hunk removing it.
- CSV lookahead: force refill when `c == '\\'` as well as `'\r'` -> fix hunk narrowing it to `'\r'`.
- Backslash handling condition `c == '\\' && (!is_csv || first_char_in_line)` -> fix hunk making it `!csv_mode` only. In CSV mode, `\.` at line start is again treated as an EOF marker (or errors "not alone on its line" if followed by text), though `\.` is valid CSV data.
- `else if (!is_csv)` on the skip-next-char branch -> fix hunk's `else` (csv-conditional restored).
- The NO_END_OF_COPY_GOTO / not_end_of_copy fallback was not restored, so `\.` followed by more text on a line errors in CSV (minimal form of the bug).

Failing oracle case: src/test/regress||copy
