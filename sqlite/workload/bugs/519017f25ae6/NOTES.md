Reproducer (repro.sql): aggorderby-5.3. A correlated subquery uses an aggregate
with ORDER BY, `group_concat(a,'#' ORDER BY d)`, where `a` is an outer column and
`d` is an inner one. Without the fix, sqlite3ReferencesSrcList() ignores columns
in the aggregate's ORDER BY.

Clean: prints `aaa#aaa` and `bbb#bbb`, exit 0.
Buggy: assertion failure `pC!=0` in sqlite3VdbeExec, abort (exit -6).
