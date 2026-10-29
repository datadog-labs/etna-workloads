# Ticket #3564: commit hook invoked recursively

Fix: added SQLITE_CommitBusy flag, set around xCommitCallback in vdbeCommit(), and
tested in sqlite3VdbeHalt() so a query run from inside the hook cannot auto-commit
(and re-invoke the hook).

In 3.54.1 the flag no longer exists. The case is covered by another path: in
sqlite3VdbeHalt() the autocommit block requires `db->nVdbeWrite==(p->readOnly==0)`;
the committing writer VM is still counted in nVdbeWrite during the hook, so a nested
read-only SELECT sees 1!=0 and does not commit.

## Change (src/vdbeaux.c, vdbeCommit)
Decrement nVdbeWrite (for a non-read-only VM) around the xCommitCallback call. This
undoes the "other path": the nested SELECT then sees nVdbeWrite==0==(readOnly==0),
enters the auto-commit branch, calls vdbeCommit and re-invokes the hook recursively,
which is exactly the behaviour the fix's `SQLITE_CommitBusy` guard in Halt prevented.
No flag was added, so the Halt hunk has nothing to remove.

## Oracle failures
hook-3.5 onward (any commit hook running a nested query) and hook-3.10 fail: debug
build asserts `nWrite==db->nVdbeWrite` in checkActiveVdbeCnt during the nested
statement; the run aborts so later cases are reported failing too.
