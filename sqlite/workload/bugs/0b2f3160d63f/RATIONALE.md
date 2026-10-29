# Rationale

Fix hunk reversed: `src/vdbeaux.c` sqlite3VdbeRecordCompare, where
`if(...aSortOrder[i]) rc=-rc` moved into an `else` so DESC inversion applies only
when a field differs, not when one key runs out of fields (the default result).
The pre-fix code also inverted that "ran out of fields" result when the next
index column was DESC.

In 3.54.1 the compare is split up, so the same defect is restored in each place
that returns `default_rc` after equal prefix fields:
- `sqlite3VdbeRecordCompareWithSkip` (end of function): returns `-default_rc` if
  `aSortFlags[i]` is set for the next column `i`.
- `vdbeRecordCompareInt` and `vdbeRecordCompareString` (single-field-prefix
  `default_rc` return): same inversion using column 1's sort flag.
- Debug-only `vdbeRecordCompareDebug`: same inversion, so the assert()
  cross-checks still agree and the failure is a wrong result, not an assert.

Not reverted: the where.c `nNotNull` hunk (OP_IdxIsNull no longer exists) and
the vdbe.c Stringify/assert hunk (OP_MoveGt removed); comment/Id hunks are no-ops.

## Oracle failures
descidx1-4.3, 4.4, 4.5, 4.6 fail with wrong (empty) results: seeks on
i3(a ASC, b DESC, c ASC) with a prefix key whose next column is DESC land past
the matching rows.
