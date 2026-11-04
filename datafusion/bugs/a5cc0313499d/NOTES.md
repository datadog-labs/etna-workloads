Reproducer: `(SELECT x FROM t2 UNION ALL SELECT x FROM t2) UNION ALL BY NAME SELECT 5 ORDER BY x`
with target_partitions=4.

df-clean returns the rows. df-buggy fails with a `SanityCheckPlan` error
("does not satisfy order requirements") because the injected `constants.is_empty()`
check in the union equivalence-ordering builder drops the ordering when constants exist.
The second query in repro.sql behaves the same on both builds.
