# Rationale

Two changes, each reversing a hunk of fix.patch.

1. `src/insert.c` (sqlite3GenerateConstraintChecks, "no collision possible" skip):
   `if( isUpdate && pPk==pIdx && pkChng==0 )` -> `if( isUpdate && pPk && pkChng==0 )`.
   Reverses the fix hunk that narrowed the skip to the PRIMARY KEY index. Pre-fix, an UPDATE
   of a WITHOUT ROWID table that leaves the PK unchanged skipped uniqueness checks on *every*
   index, including secondary UNIQUE indexes.

2. `src/update.c` (old-value loading in sqlite3Update): the PRIMKEY-column term is again
   `(chngPk && (colFlags & COLFLAG_PRIMKEY)!=0)` instead of unconditional, reversing the
   update.c hunk. With FK/trigger-driven old-row loading and an unchanged PK, PK columns
   are no longer loaded into the old-register set (NULL instead).

The other fix hunks (assert changes in build.c, the "PRIMARY KEY must be unique" message)
are not needed/already differently represented in 3.54.1.

## Oracle failures
test/without_rowid1.test: 10.2, 10.3, 10.4, 10.6, 11.1, 12.1 fail (missed UNIQUE
violations on secondary indexes: e.g. 11.1 yields "non-unique entry in index" from integrity check,
12.1 gets UNIQUE constraint failure / wrong results).
