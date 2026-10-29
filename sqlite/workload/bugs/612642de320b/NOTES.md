`repro.sh` builds a table whose CHECK constraint (`abs(x)>=0`) is bypassed in the source via `PRAGMA ignore_check_constraints=1`, stores `-9223372036854775808`, then runs `.clone new.db`. In the new database the INSERT fails with an integer overflow in `abs()`. `.clone` calls `sqlite3_step()` and prints `sqlite3_extended_errcode()`/`sqlite3_errmsg()` before resetting the statement.

Clean: `Error 1: integer overflow`. Buggy: `Error 0: not an error`. The bug leaves the db error code unset after `sqlite3_step()` on a prepare_v2 statement.
