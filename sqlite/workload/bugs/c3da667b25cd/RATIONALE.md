# Rationale

Reverted the fix's save/restore of `db->nChange` around trigger programs. The `p->nChange=0` additions in `sqlite3VdbeHalt` were not reverted. Each is a line-for-line removal of an addition from the fix.

- `src/vdbe.c`, `OP_Program`: removed `pFrame->nDbChange = p->db->nChange;`. This reverses the fix's `vdbe.c` hunk.
- `src/vdbeaux.c`, `sqlite3VdbeFrameRestore`: removed `v->db->nChange = pFrame->nDbChange;`. This reverses the fix's `vdbeaux.c` hunk. Without the save there is nothing valid to restore, so both lines go together.

The `nDbChange` field in `VdbeFrame` stays. It is now unused.

After a trigger program exits, `sqlite3_changes()` is no longer restored to its value from before the trigger.

## Oracle cases that fail (`./check.sh`)

- `e_changes-5.1.1` and `e_changes-5.1.2`: `changes()` after the first trigger run reads 0 instead of 2.
- `e_changes-5.2.1` and `e_changes-5.2.2`: `changes()` reads 0 instead of 3 on the second and later rows.
