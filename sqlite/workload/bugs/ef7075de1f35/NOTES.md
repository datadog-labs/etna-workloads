Reproducer: `EXPLAIN QUERY PLAN SELECT count(*) FROM t1;`.
Clean shell prints a plan row ("SCAN t1 USING COVERING INDEX i1"); the buggy shell omits it, because the patch removes the explainSimpleCount() call for the count(*) optimization (eqp-7.3 and others).
