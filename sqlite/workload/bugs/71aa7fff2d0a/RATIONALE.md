# Rationale

## Bug (ticket #3127, fixed 2008-05-20)

The fix's single implementation hunk wraps the super-journal-name-write
logic in `sqlite3PagerCommitPhaseOne()` (`src/pager.c`) inside
`if( pPager->journalMode!=PAGER_JOURNALMODE_OFF ){ ... }`. Before the fix,
when a multi-file transaction committed with `journal_mode=off` on one of
the participating databases, the pager would still call
`writeMasterJournal()` (now `writeSuperJournal()`) to write the
super-journal name into the journal file of the `OFF`-mode database --
except that database never opens a journal file in `OFF` mode, so the
write/truncate calls operate on an unopened `sqlite3_file`, corrupting
memory / crashing.

The fix's own regression test, `jrnlmode-3.1`/`jrnlmode-3.2` added to
`test/jrnlmode.test`, reproduces this with a `main` database in
`journal_mode=off`, an attached database in the default mode, and a
transaction that writes to both (making it a multi-file commit).

## Where the logic lives in 3.54.1, and why one hunk alone isn't enough

### 1. `writeSuperJournal()` in `src/pager.c` -- the direct successor of the fix

`writeMasterJournal()` was renamed `writeSuperJournal()`. Its early-exit
guard today is:

```c
if( !zSuper
 || pPager->journalMode==PAGER_JOURNALMODE_MEMORY
 || !isOpen(pPager->jfd)
){
  return SQLITE_OK;
}
```

The `!isOpen(pPager->jfd)` clause is the modern equivalent of the fix's
`journalMode!=PAGER_JOURNALMODE_OFF` guard: in `OFF` mode `pPager->jfd` is
never opened, so this clause is what currently prevents the super-journal
name from being written to a non-existent journal file. This traces
directly to the fix's hunk in `src/pager.c` (the only implementation hunk
in `fix.patch`).

**Change:** removed the `|| !isOpen(pPager->jfd)` clause, restoring:

```c
if( !zSuper
 || pPager->journalMode==PAGER_JOURNALMODE_MEMORY
){
  return SQLITE_OK;
}
```

### 2. `aMJNeeded[]` in `src/vdbeaux.c` -- a second, independent safeguard added later that also covers this case

In 3.54.1, `sqlite3VdbeHalt()` (formerly part of the same commit logic
that contained `sqlite3PagerCommitPhaseOne` call sites in 2008) decides
whether a transaction needs the "complex", super-journal-based commit path
at all. It only takes that path when more than one participating database
"needs" a master/super-journal, per a lookup table:

```c
static const u8 aMJNeeded[] = {
  /* DELETE   */  1,
  /* PERSIST   */ 1,
  /* OFF       */ 0,   /* <- excludes OFF-mode databases from the count */
  /* TRUNCATE  */ 1,
  /* MEMORY    */ 0,
  /* WAL       */ 0
};
```

This table does not exist in `fix.patch` and was introduced independently
of the 2008 fix (SQLite's commit-path logic was substantially reworked,
notably for WAL, after 2008). However it addresses exactly the same
category of defect: it was designed so that a database in a
non-journaling mode (`OFF`/`MEMORY`) is not treated as requiring
super-journal participation. Its practical effect is that a two-database
transaction consisting of one `OFF`-mode db and one normal-mode db (e.g.
`jrnlmode-3.2`'s scenario) is now routed through the *simple* single-file
commit path, which never calls `writeSuperJournal()` with a non-NULL
`zSuper` at all -- so hunk 1 alone is masked for exactly the oracle's own
regression test.

This is the "fixed twice" situation from TASK.md point 4: the `OFF` entry
in `aMJNeeded[]` means an `OFF`-mode database is no longer considered to
need super-journal protocol, independently re-closing the same hole that
the 2008 fix closed for the two-database case. Reverting only hunk 1
leaves this second path intact and the two-database reproduction
(exactly what the fix's own test exercises) inert. Note that with 3+
databases (2 normal-mode databases plus 1 `OFF`-mode database), `nTrans`
from the two normal-mode databases already exceeds 1, so the complex path
is taken regardless of the `OFF` entry, and the `OFF` database's
`sqlite3PagerCommitPhaseOne()` is still called with a real `zSuper` --
manually confirmed to crash (`sqlite3` CLI, 3 attached databases, segfault
on commit) even with only hunk 1 reverted. But the *oracle's own* test
uses only two databases, so hunk 2 is required to reproduce it.

**Change:** set `aMJNeeded[PAGER_JOURNALMODE_OFF]` back to `1`, restoring
the pre-optimization count so that an `OFF`-mode database with an active
write transaction is counted the same as `DELETE`/`PERSIST`/`TRUNCATE`
when deciding whether the complex commit path is needed. `MEMORY` is left
at `0`; it's unrelated to this ticket and `writeSuperJournal()` already
has its own independent `journalMode==PAGER_JOURNALMODE_MEMORY` guard that
the fix never touched.

## Verification

Oracle file `test/jrnlmode.test` (all 97 of its cases are in the oracle).
Running `./check.sh`:

```
== test/jrnlmode.test: 71 of 97 oracle cases failing: [...] (incomplete run: crash, assert or timeout)
```

The detailed log shows the run proceeds correctly through `jrnlmode-1.*`,
`jrnlmode-2.*` and `jrnlmode-3.1`, then crashes partway through
`jrnlmode-3.2` -- precisely the test case the fix's author added to guard
against ticket #3127 -- taking down every subsequent case in the file.
This is both a genuine crash and a failure that resembles exactly what the
fix's own test was written to catch.
