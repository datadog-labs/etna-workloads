Reproducer: repro.sql runs the bloom1-6.1 query (IN with a UNION ALL subquery on the RHS, one arm reading an empty table).
Clean shell prints 0. Buggy shell aborts with `Assertion 'pIn1->flags & MEM_Blob' failed` in sqlite3VdbeExec (exit 134).
Cause: the injected change turns the Bloom filter opcode into a no-op when it goes unused, but OP_Filter is still generated.
