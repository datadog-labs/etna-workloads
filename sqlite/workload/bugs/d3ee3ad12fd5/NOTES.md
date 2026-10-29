Reproducer (`repro.sql`): table with a constant, indexed virtual column (`c0 UNIQUE AS(0)`), then a one-pass UPDATE using that index.

Clean shell: prints `0|0|0` and integrity_check `ok`.
Buggy shell: the deferred seek is never finished before the row DELETE/INSERT, so it aborts with the assertion `pC->deferredMoveto==0` (exit status -6).
