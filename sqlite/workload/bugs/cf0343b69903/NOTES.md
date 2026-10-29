`repro.sql` runs `percent_rank() OVER ()` and `cume_dist() OVER ()` over a 3-row table (no ORDER BY, so no aggregate context exists when the step function runs).

- Clean shell: prints 0.0 x3 and 1.0 x3, exit 0.
- Buggy shell: aborts with `Assertion 'sqlite3VdbeAssertAggContext(pCtx)' failed` in percent_rankStepFunc (exit -6).

The injection re-adds those asserts, which the fix removed because they are wrong.
