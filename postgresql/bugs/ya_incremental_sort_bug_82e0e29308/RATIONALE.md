# Rationale

File: src/backend/executor/nodeIncrementalSort.c, function switchToPresortedPrefixMode().

Traces to the single fix.patch hunk, which adds `lastTuple = false;` on the
batch-boundary path. The current code no longer has a `lastTuple` variable. The
loop is now `for (nTuples = 0; nTuples < n_fullsort_remaining; nTuples++)`, and
the boundary path breaks without counting the boundary tuple.

I restored the bug by treating a boundary found at the last tuple of the batch
as if all tuples were consumed (`nTuples++` before the `break`). This is the old
behaviour, where the code took the "consumed everything" path in that case.
n_fullsort_remaining then reaches 0 and the node goes to INCSORT_LOADPREFIXSORT.
It uses the next group's first tuple as the pivot and never sorts or returns
the current batch properly. The result is wrong answers or a
"retrieved too many tuples in a bounded sort" error.

Failing oracle case: src/test/regress||incremental_sort
