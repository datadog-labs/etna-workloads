`repro.sql` runs the two queries from test/tkt3541.test: `CASE ~max(x) WHEN min(x) ...` and `CASE NOT max(x) WHEN min(x) ...` over a one-row table.
Clean shell prints 123 and 123. Buggy shell prints an empty line (NULL) and 0, because `~` and `NOT` are not two-address instructions, so the aggregate result is wrong.
