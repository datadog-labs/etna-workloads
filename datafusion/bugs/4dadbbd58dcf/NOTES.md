Reproducer: a recursive CTE with a column-list alias, `WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM t WHERE n < 10)`.

- df-clean: returns rows 1..10.
- df-buggy: fails to plan with `Schema error: No field named n. Valid fields are t."Int64(1)".` The declared column names are not applied to the static term before the work table is built.
