# Rationale

The fix added `bUpdateOrDelete = 1;` after `fts5SpecialDelete()` in `fts5UpdateMethod`. That flag drove the old design: after a DELETE/UPDATE with secure-delete on, `fts5UpdateMethod` wrote `version=5` (SECUREDELETE) to `%_config`. `integrity-check` uses that version (`iVersion`) to decide whether secure-delete page layouts are legal. The 'delete' special command did not set the flag, so no version bump happened and integrity-check reported corruption.

In 3.54.1 the flag is gone, and `fts5FlushSecureDelete()` sets the version at flush time. That covers the case, so reversing the hunk is impossible. I restored the old design with the fix's omission.

## Changes
1. `ext/fts5/fts5_main.c`, `fts5UpdateMethod`: a `bUpdateOrDelete` local, set in the DELETE (`nArg==1`) and UPDATE branches. It is deliberately not set in the special 'delete' branch, which is the line the fix added. At `update_out`, if the flag is set and `bSecureDelete` is on, the version is written as SECUREDELETE and `iVersion` is updated.
2. `ext/fts5/fts5_index.c`, `fts5FlushSecureDelete`: removed the "set version to SECUREDELETE" block. It is the second path covering the same case, and it is the same defect. Leaving it in would mask the bug.

## Oracle
`fts5secure8-2.1` fails. With a contentless table in secure-delete mode, the sequence insert 1, insert 2, special 'delete' of 2 leaves the version unset, and `pragma quick_check` reports corruption instead of `ok`. The other 14 cases pass.
