# Rationale

Version 3.54.1 already contains the fix's structure (`zipfileRemoveEntryFromList`,
`pOld2`, the two-entry cleanup block), so the fix cannot be reversed hunk by hunk.
I reverted only the hunk that carried the defect.

## Changed hunk (ext/misc/zipfile.c, zipfileUpdate)

Fix hunk reversed: `case SQLITE_REPLACE: { pOld = p; ... }` became `pOld2 = p;`.

Pre-fix code stored the conflicting entry found by the duplicate-name scan in
`pOld`. For `UPDATE OR REPLACE ... SET name=<existing>`, `pOld` already holds the
entry being updated, so it is overwritten. The entry being updated is then never
removed from the list, and the conflicting entry is removed instead. The
`pOld2` variable and the cleanup code that handles both entries are left in place
but are now unused for this case.

## Oracle failure

`zipfile2-6.3` fails. It expects `test2` and gets `test1 test2`, because the
`test1` entry that was renamed is never removed.
