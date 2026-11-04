repro.sql runs the regression query from the fix: GROUP BY an aliased column with `ORDER BY 2 DESC`, where 2 is the mixed-case alias `"Count"`.
Clean build returns the row `foo | 1`. Buggy build fails planning with "Column in ORDER BY must be in GROUP BY or an aggregate function", because the alias is lowercased to `count`.
