# Rationale

The fix's two hunks in `generateSortTail()` are still present in 3.54.1 and
reversing them alone changes nothing: for SRT_Table/SRT_EphemTab the sorter
holds one packed record, and the generic column-reading loop happens to land
the record in `regRow`. The pre-fix bug only shows when the OMITREF
optimization (columns copied from ORDER BY omitted from the sorter record)
also applies to those destinations. 3.54.1 excludes them in `selectInnerLoop()`,
so I reverted that too.

Changes in `src/select.c`:
1. `generateSortTail`: restored `regRow = sqlite3GetTempRange(pParse, nColumn)`
   and dropped the `nColumn = 0` special case (fix hunk 1).
2. `generateSortTail`: removed the `OP_Column iSortTab, nKey+bSeq, regRow` before
   `OP_NewRowid` in the SRT_Table/SRT_EphemTab case (fix hunk 2).
3. `selectInnerLoop`: condition is `if( pSort && hasDistinct==0 )` again,
   dropping `&& eDest!=SRT_EphemTab && eDest!=SRT_Table`. This is the later
   guard that covers the same defect on the select side (named here per task rule 4).

## Oracle results
with1-21.1b (the fix's added case) fails with an assertion in `selectInnerLoop`
(`eDest==SRT_Set || ...`), and the following with1 cases fail because the run aborts
(17 cases total). select1-17.x still pass.
