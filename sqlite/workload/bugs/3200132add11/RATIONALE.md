# Rationale

Fix: each trigger program (VdbeFrame) gets its own AuxData list, so
sqlite3_get/set_auxdata does not leak across triggers. 3.54.1 still has this
(VdbeFrame.pAuxData, `sqlite3VdbeDeleteAuxData`), but the fix hunks no longer
reverse textually. I removed the three uses of the per-frame list:

- src/vdbe.c OP_Program: removed the `pFrame->pAuxData = p->pAuxData; p->pAuxData = 0;`
  save/clear (reverses the vdbe.c hunk). Trigger programs now share the parent's list.
- src/vdbeaux.c sqlite3VdbeFrameRestore: removed the delete + restore of
  `v->pAuxData` from the frame (reverses the FrameRestore hunk).
- src/vdbeaux.c sqlite3VdbeFrameDelete: removed the `sqlite3VdbeDeleteAuxData`
  of the frame's list (reverses the deleteAuxdataInFrame call; nothing is ever
  stored there now). The struct field is left in place (harmless).

Oracle failures: regexp2-1.1 and regexp2-3.0. Triggers tr1/tr2 reuse each
other's compiled REGEXP aux-data (same iOp/arg), so x1 gets wrong results.
