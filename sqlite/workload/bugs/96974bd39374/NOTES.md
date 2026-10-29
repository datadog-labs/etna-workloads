`repro.sql` builds t1(a,b) with an index on a, loads 10000 rows with 500-byte random blobs
under `cache_size=5`, then runs `SELECT ... ORDER BY a, b`. That is a partial sort, and it is
large enough for the sorter to spill to disk, as in orderby1-8.3.

- clean: prints `5000|10000`.
- buggy: aborts with `Assertion 'pTask->nPMA==0' failed` in vdbeSorterListToPMA (exit -6).
  The injection stops `sqlite3VdbeSorterReset` from clearing the subtask or restoring
  `pTask->pSorter`, so state is left over when the sorter is reset between partial-sort groups.
