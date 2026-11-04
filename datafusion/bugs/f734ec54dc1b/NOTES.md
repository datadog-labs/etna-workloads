Reproducer: copies the joins.slt regression test. t1 has 5 rows with all-NULL column a; a subquery with ORDER BY b LIMIT 1 is joined to t2.
The limit caps num_rows to 1 but null_count stays 5, so max_distinct_count in the buggy build does an unchecked subtraction (1 - 5) and panics with overflow. The clean build returns an empty result.
