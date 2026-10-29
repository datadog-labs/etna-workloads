# Rationale

Both hunks of the fix to `sqlite3FkDropTable()` in `src/fkey.c` are reversed. The function has barely changed since the fix, so they reverse directly.

1. The loop that looks for a deferred FK on the child table went back to `if( p->isDeferred ) break;`. This removes the `|| (db->flags & SQLITE_DeferFKs)` test that the fix added.
2. The `OP_FkIfZero` and `sqlite3HaltConstraint` pair is no longer wrapped in `if( (db->flags & SQLITE_DeferFKs)==0 )`. It is emitted unconditionally again. The explanatory comment about `SQLITE_DeferFKs` is removed too. The surrounding modern code (`sqlite3VdbeVerifyAbortable`, `VdbeCoverage`, `P5_ConstraintFK`) is kept.

With `PRAGMA defer_foreign_keys=1`, DROP TABLE therefore raises an immediate FK constraint error. This is the pre-fix behaviour.

## Oracle failures (test/fkey6.test)

`./check.sh` reports 5 errors: fkey6-2.3, 2.4, 2.5, 2.6 and 3.2.1.

- fkey6-2.3 and 2.4 fail because DROP TABLE aborts with "FOREIGN KEY constraint failed".
- fkey6-2.5 and 2.6 fail as follow-on errors, probably from state left behind by the failed tests before them. I did not check this.
- fkey6-3.2.1 I did not look into.
