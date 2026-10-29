# Rationale

Change is in `tree/src/build.c`, `sqlite3CreateIndex()`. It reverses the `src/build.c` hunks of the fix.

1. Hunk 1 (`-3921`): restored the old insertion-time ordering. In the `db->init.busy || pTblName==0` branch, a new OE_Replace index is spliced in before the first existing REPLACE index. Other indexes are still pushed at the head. This is the pre-fix code, including its comment.
2. Hunk 2 (`-3952`): removed the `exit_create_index` block that re-sorted all REPLACE indexes to the end of the list. In 3.54.1 that block also had a SQLITE_DEBUG verification loop, which I removed with it. Without the block, an existing index whose `onError` is changed to REPLACE by the duplicate-constraint merge (`pIdx->onError = pIndex->onError`) stays where it is in the list.
3. Hunk 3 (`insert.c` assert in `sqlite3CompleteInsertion`) is already present in 3.54.1 and was left unchanged. It is what catches the bug in debug builds.

## Oracle failures
`conflict-15.10` fails. For `x PRIMARY KEY, UNIQUE(x,x), UNIQUE(x,x) ON CONFLICT REPLACE`, the second UNIQUE merges into the first and turns it into a REPLACE index. That index now sits ahead of the non-REPLACE autoindex. `testfixture` aborts on the assertion in `sqlite3CompleteInsertion`: `pIdx->onError!=OE_Replace || pIdx->pNext==0 || pIdx->pNext->onError==OE_Replace`. The 15.20 and 15.30 cases do not run after the abort. In a non-debug build the same mis-ordering gives out-of-order constraint processing.
