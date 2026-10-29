# Rationale

Fix hunk (src/alter.c, sqlite3AlterBeginAddColumn): after memcpy'ing the Column
array into the scratch table, the fix added `pCol->zColl = 0;` so the scratch
copy did not share the collation-sequence name with the original table
(which led to a double free / dangling pointer for tables with COLLATE).

In 3.54.1 the collation name is stored inside `Column.zCnName` (after the
name's NUL, flagged by COLFLAG_HASCOLL), and the loop in
sqlite3AlterBeginAddColumn duplicates `zCnName` for each column, so the copy
owns its own name+collation. The change in `tree/src/alter.c` restores the old
behaviour: columns that have a collation are no longer duplicated, so the
scratch table shares the collation storage with the original table (as the
un-nulled `zColl` did) and both free it.

## Oracle
test/alter.test `alter-7.1` (the case the fix added: ADD COLUMN on a table with
a COLLATE column) fails: assertion in sqlite3DeleteColumnNames
(`pCol->zCnName==0 || pCol->hName==sqlite3StrIHash(pCol->zCnName)`), caused by
the shared/freed column name storage.
