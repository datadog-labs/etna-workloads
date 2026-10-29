# Rationale

Fix (2014-02-09) made WITH-clause name resolution work for the left-hand SELECTs of a compound
query, by looking up the WITH on the rightmost select (`findRightmost(p)->pWith` in
`selectExpander` and `selectPopWith`). The pRightmost/pNext/SF_Compound machinery it
introduced is now structurally different in 3.54.1 (parserDoubleLinkSelect), so I reverted only the WITH-lookup hunks.

Changes, all in `tree/src/select.c`:
- `sqlite3SelectPopWith`: reverses the `selectPopWith` hunk. Back to using `p->pWith`
  (pre-fix) instead of `findRightmost(p)->pWith` and the `p->pPrior==0` guard.
- `selectExpander` (the `sqlite3WithPush(pParse, p->pWith, 0)` line) already uses `p->pWith`
  in 3.54.1, i.e. the pre-fix form. Its findRightmost lookup is provided today by
  the leftmost-first walk plus the pop in the callback, so no edit was needed there.
  (Revert of the pop alone is what re-breaks the push/pop pairing.)

Oracle failures (test/with1.test): with1-12.1 (the fix's own test, the CTE
EXCEPT query with ORDER BY), plus with1-17.2 (x2), 17.7, 17.8. Left-side SELECTs of compounds no
longer resolve names via the WITH stack properly (the WITH is popped by the wrong select).
