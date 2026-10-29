repro.sql: two AFTER INSERT triggers on t1 each call REGEXP on new.a/b/c with a
different constant pattern ('abc' vs 'def'). Without a per-trigger-program
aux-data list, the second trigger reuses the regexp compiled by the first.
Clean: x1 = 1|0|1, x2 = 0|1|0. Buggy: x1 = 0|1|0 (wrong result).
(regexp2-1.1 of test/regexp2.test.)
