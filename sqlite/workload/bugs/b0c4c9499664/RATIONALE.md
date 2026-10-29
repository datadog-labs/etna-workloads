# Rationale

Fix: in btreeMoveto(), reject an unpacked index key whose `nField` exceeds
`pKeyInfo->nAllField` as SQLITE_CORRUPT (e.g. INSERT INTO ... SELECT * or
VACUUM copying index records that have more columns than the cursor's KeyInfo).

## Changes

1. `src/btree.c` btreeMoveto(): dropped `|| pIdxKey->nField>pKeyInfo->nAllField`
   from the corruption test. This reverses the fix hunk directly (the local
   `pKeyInfo` variable is kept; it is still used).
2. `src/vdbeaux.c` sqlite3VdbeRecordCompareWithSkip(): the trailing
   `idx1>=szHdr1 -> SQLITE_CORRUPT_BKPT` check was replaced by `break`. Reversing
   hunk 1 alone is not enough: the oversized key (nField = nKeyField+1 >
   nAllField) is then caught later, when the compare runs off the end of the
   stored record. This is the "bug fixed twice" path: in the pre-fix code the
   compare loop simply ended when the record header was exhausted (and the
   key was treated as equal up to that point, returning default_rc), so the
   oversized key was never reported as corruption.

## Oracle failures

- corruptL-3.1 (the fix's own test): `INSERT INTO t1 SELECT * FROM t2` now
  succeeds / hits the UNIQUE path instead of returning "database disk image is malformed".
- corruptL-19.2, corruptL-19.4: other corrupt-index cases that relied on the
  hardening in change 2 now return a UNIQUE error / success instead of corruption.
