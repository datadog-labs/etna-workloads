Reproducer for index6-11.1: a partial index `t11x ON t11(a) WHERE b<>99` and `EXPLAIN QUERY PLAN SELECT a FROM t11 WHERE b<>99`.
Clean shell: `SCAN t11 USING INDEX t11x`. Buggy shell: `SCAN t11`, because rSize is not reset per index, so the partial index's smaller row estimate is ignored.
