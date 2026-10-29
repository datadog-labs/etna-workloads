# Rationale

## Change
`tree/src/build.c`, `convertToWithoutRowidTable()`: the loop that marks PRIMARY KEY
columns NOT NULL now assigns `OE_Rollback` (value 1) instead of `OE_Abort`.

Reverses the fix hunk `notNull = OE_Abort` -> (pre-fix) `notNull = 1`. In 3.54.1 the
code is guarded by `notNull==OE_None` and the pre-fix literal `1` equals `OE_Rollback`,
so the implied NOT NULL on a WITHOUT ROWID PK again has ROLLBACK conflict
resolution rather than ABORT. The other `OE_Abort` site (sqlite3AddColumn-area loop,
~line 2789) is left alone; the WITHOUT ROWID conversion path is the one that
changed in the fix.

## Oracle failures
- `without_rowid5-5.2b`: inserting NULL into a WITHOUT ROWID PK inside BEGIN now rolls
  back the whole transaction, so the following ROLLBACK errors with
  "cannot rollback - no transaction is active".
- conflict2 cases covering WITHOUT ROWID PKs (t-values for the NOT NULL rows) are
  also expected to differ, since ROLLBACK semantics apply instead of ABORT.
