Reproducer (repro.sql): creates a table whose column name contains double quotes (`"cb"`), then runs `SELECT *` and `SELECT "t a".*` on it. This is tkt2450-2/3.

Clean shell prints `1` for both queries (exit 0). Buggy shell fails to quote/escape the expanded identifiers and reports `Parse error: no such column: "cb"` for both (exit 1).

`./check.sh` fails under the sandbox (bwrap bind-mount error), so I compared the two shells by running them directly.
