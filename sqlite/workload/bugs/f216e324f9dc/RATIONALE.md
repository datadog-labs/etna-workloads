# Rationale

Fix hunk (src/btree.c, insertCell): split the assert
`nCell<=MX_CELL && MX_CELL<=10921` into two and added `|| CORRUPT_DB` to the nCell check,
because a corrupt database can have a page with more cells than MX_CELL.

Reverted in tree/src/btree.c: the combined assert without `CORRUPT_DB`, in `insertCell`
and in `insertCellFast` (the later copy of the same function body, same assert, same defect).

Oracle: corruptI-3.2 aborts with the assertion failure in insertCellFast
(`pPage->nCell<=MX_CELL(pPage->pBt) && ...`), so 3.2 onward do not run (16 of 23 cases fail).
