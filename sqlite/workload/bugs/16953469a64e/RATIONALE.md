# Rationale

## Change
`tree/src/alter.c`, `sqlite3AlterDropColumn()`: removed the pre-check call
`renameTestSchema(pParse, zDb, iDb==1, "", 0);` that ran before the
`UPDATE sqlite_schema SET sql = sqlite_drop_column(...)`.

This reverses the fix hunk that added `renameTestSchema(pParse, zDb, iDb==1, "")`
ahead of the drop-column UPDATE. That call detected schema objects that were
already broken before the DROP COLUMN, so they could be reported as
"error in view v1: ..." without the "after drop column" suffix. Without it,
pre-existing errors are only found by the post-reload check, or not
reported in the right form.

The other fix hunks (the zWhen parameter plumbing) are already in 3.54.1 and
are left untouched.

## Oracle failures
alterdropcol-5.2.2, 5.4.2 and 5.5.2 fail. Instead of the expected
"error in view v1: no such column: d" or "error in trigger tr: ...",
the statement returns the generic `{1 {SQL logic error}}`.
