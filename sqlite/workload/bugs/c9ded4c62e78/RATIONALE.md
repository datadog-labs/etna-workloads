# Rationale

Fix hunk (src/insert.c, autoIncBegin, ticket #3148) added an `OP_Integer 0` to the
sqlite_sequence-scan program, reached when the scan finds no row for the table,
so the max-rowid register is a sane integer 0 rather than NULL.

In 3.54.1 this program is the static `autoInc[]` list in
`sqlite3AutoincrementBegin()` (src/insert.c). Changes:
- Removed the `{OP_Integer, 0, 0, 0}` entry (index 10) and its `aOp[10].p2 = memId`.
- Renumbered the jump targets: `OP_Rewind` p2 11->10... i.e. Rewind and Goto now jump to the
  OP_Close (now index 10) directly, skipping nothing, so the register stays NULL
  (set by the initial OP_Null) when no entry exists.

Same as pre-fix code, where the Rewind/Goto jumped straight to Close.

Oracle: autoinc-9.1 fails (`INSERT INTO t3 SELECT ... ` empty leaves sqlite_sequence
row for t3 with NULL instead of 0). Verified with ./check.sh: 1 error, autoinc-9.1.
