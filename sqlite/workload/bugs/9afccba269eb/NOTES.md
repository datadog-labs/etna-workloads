repro.sql: a recursive CTE whose recursive step joins a view containing ORDER BY (the test with2-8.3 case).
Clean shell prints 1..5 and exits 0. The buggy shell aborts with an assertion failure in selectInnerLoop (exit status -6),
because the injection stops ORDER BY being ignored for SRT_Fifo/SRT_Queue destinations.
