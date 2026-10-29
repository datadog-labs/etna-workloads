Reproducer: `repro.sql` runs `SELECT value FROM generate_series WHERE value IN (1,2,3);`.

The bug: for a single virtual table with a plan that uses IN(...) and needs no
other tables, the planner skipped the second xBestIndex call (IN disabled).
The upstream test counts those calls with a Tcl vtab; the shell has no such
vtab, so this uses generate_series, whose xBestIndex errors when that second
call has no usable start/value constraint.

- clean: `Parse error near line 1: first argument to "generate_series()" missing or unusable`, exit 1
- buggy: the second call is never made, so the query returns 1, 2, 3, exit 0
