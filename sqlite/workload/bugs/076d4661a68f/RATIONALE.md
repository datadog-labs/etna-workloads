# Rationale

Ticket #3663: auto_vacuum=INCREMENTAL (2) was lost across VACUUM.

## Change: `sqlite3BtreeSetAutoVacuum()` in tree/src/btree.c
Reverses the sole implementation hunk of fix.patch. The code still had the
fixed form, so it is restored to the pre-fix form:
- `u8 av = (u8)autoVacuum;` -> `u8 av = autoVacuum ?1:0;` (value 2 collapsed to 1)
- `(av ?1:0)!=pBt->autoVacuum` -> `av!=pBt->autoVacuum`
- `pBt->autoVacuum = av ?1:0; pBt->incrVacuum = av==2 ?1:0;` -> `pBt->autoVacuum = av;`
  (incrVacuum is no longer set from the requested mode)

vacuum.c passes db->nextAutovac (from `PRAGMA auto_vacuum=2`) to the temp
db's SetAutoVacuum, so the incremental flag is dropped in the vacuumed file.

## Oracle failures
vacuum2-4.5 (expected 2, got 1) and vacuum2-4.7 (expected 2 after reopen, got 1).
