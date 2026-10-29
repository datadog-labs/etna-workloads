Reproducer (`repro.sql`): runs `max(y) OVER (PARTITION BY x%2 ORDER BY x)` over a small table.
The injection makes min()/max() use the finalizer, which releases the accumulator, as their window xValue.
Clean shell prints the correct rows (`4|g|i`, `5|a|l`, ...). Buggy shell aborts with
`Assertion 'pKey1 && pKey2' failed` in sqlite3BinaryCompare (exit status -6).
