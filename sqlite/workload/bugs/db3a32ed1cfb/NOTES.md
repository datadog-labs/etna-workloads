repro.sql builds the windowA test table (with NULLs in d) and runs a RANGE frame `2.50 PRECEDING AND 0.5 PRECEDING` over `ORDER BY d DESC NULLS FIRST`.
The clean shell prints the correct rows and exits 0.
The buggy shell aborts with `Assertion `op==OP_Le' failed` in windowCodeRangeTest (exit -6), because the OP_Lt case is no longer handled.
