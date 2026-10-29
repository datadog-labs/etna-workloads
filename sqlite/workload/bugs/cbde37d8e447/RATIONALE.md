# Rationale

Fix: ALTER TABLE RENAME mishandled `table.*` in SELECTs inside triggers (selectExpander in src/select.c).

Both hunks of the fix are reversed in `selectExpander` (tree/src/select.c). Today's code has the same structure but a larger condition.

1. The fix added `|| IN_RENAME_OBJECT` to the condition that decides whether expanded columns are qualified as `tbl.col`. I removed `|| IN_RENAME_OBJECT` from the current condition. During a rename, `t1.*` is again expanded to bare column names, so the table-name token is never recorded for renaming.
2. The fix added `sqlite3RenameTokenRemap(pParse, pLeft, pE->pLeft)` so the new `tbl` token maps to the original `t1` in `t1.*`. I removed that call. The code is now equivalent to the pre-fix code. The fix's blank-line hunk is cosmetic and was not touched.

Failing oracle cases: altertab3-29.3 through 29.7. After `RENAME x TO z` and `RENAME TO t2`, the trigger's `t1.*` is not rewritten correctly. The later rename and the trigger schema checks then fail or produce the wrong SQL.
