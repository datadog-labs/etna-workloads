`repro.sql` creates a table with `CHECK(date(x) BETWEEN ...)` and inserts x='now'.

- clean: `Error near line 3: non-deterministic use of date() in a CHECK constraint`
- buggy: the error message is replaced by the current date (`Error near line 3: 2026-10-29`), because the injection removes `return 0` after the error is set in the not-pure-function check.

Caveat: the buggy output contains today's date, but the clean output is deterministic, so the outputs differ.
