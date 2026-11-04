repro.sql runs string_agg with ORDER BY v ASC and ORDER BY v DESC in one query, printing the EXPLAIN plan and the result.
Clean: StringAgg::reverse_expr lets the DESC aggregate reuse the ASC ordering, so the physical plan has a SortExec (v ASC) under the AggregateExec.
Buggy: reverse_expr is missing, so the plan has no SortExec at all; the aggregate relies on its own ordering.
Query results are identical in both builds. Only the EXPLAIN plan differs.
