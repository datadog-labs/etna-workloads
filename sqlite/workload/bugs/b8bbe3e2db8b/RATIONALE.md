# Rationale

Fix hunk reversed: the `renameTableFunc` hunk in src/alter.c that added renaming of
the table names in the FROM clause of an UPDATE...FROM statement inside a trigger.
In 3.54.1 the FROM items are merged into `pStep->pSrc` (a[0] is the UPDATE target,
a[1..] are the FROM items), so the equivalent of the fix's `pStep->pFrom` loop is the
`pStep->pSrc` loop in `renameTableFunc`. I restricted that loop to `i<1`, so only the
target table (as before the fix) is renamed and FROM-clause tables are not.

The other two fix hunks (asserts, and moving SelectPrep of FROM subqueries in
renameResolveTrigger) are covered in 3.54.1 by the separate isSubquery loop, which is
left intact.

Result: ALTER TABLE RENAME of a table used in a trigger's UPDATE...FROM leaves the
old name in the trigger SQL, or fails with an error; altertrig-1.1 and others fail.
