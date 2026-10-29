`repro.sql` runs a compound SELECT whose arms have different column counts (`SELECT 1, 2 UNION SELECT 3`).
Clean shell: reports "SELECTs to the left and right of UNION do not have the same number of result columns" (exit 1).
Buggy shell: the check in resolve.c is gone, so it fails `assert(p->pEList->nExpr==pPrior->pEList->nExpr)` in multiSelect (abort, exit 134).
