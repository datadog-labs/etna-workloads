# Rationale (changes in tree/src/vdbesort.c)

1. `vdbeSorterNext()` final return: restored `return rc;` (fix hunk: `return (rc==SQLITE_OK ? pTask->pUnpacked->errCode : rc);`). An OOM recorded by the key comparator in `pUnpacked->errCode` is no longer reported.
2. `vdbeMergeEngineInit()` (the 3.54.1 descendant of `vdbeIncrInitMerger`) final return: restored `return rc;` (fix hunk: `return (rc==SQLITE_OK ? pTask->pUnpacked->errCode : rc);`). Same defect.
3. `vdbeSorterAddToTree()`: removed the `if( rc==SQLITE_OK )` guard around `p = pReadr->pIncr->pMerger; nDiv = ...` (fix hunk added it). After an OOM in `vdbeMergeEngineNew`/`vdbeIncrMergerNew`, `pReadr->pIncr` is NULL and is dereferenced.

Not reverted: the `vdbeSorterSort` return (current code already equals the fix's version; the pre-fix form behaved identically), the `vdbeSorterFlushPMA` condition reorder, `vdbeSorterSetupMerge` nTask changes (code was restructured), threads.c/test-only changes.

## Oracle failures
sortfault.test, `sortfault-3.4-oom-transient.*` (about 1895 cases, from .1000 on): the run crashes (NULL dereference in `vdbeSorterAddToTree`) under injected OOM. sort.test is unaffected. Hunk 3 is what produces the crash; 1 and 2 alone did not fail any oracle case.
