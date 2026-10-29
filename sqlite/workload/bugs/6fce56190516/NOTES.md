Reproducer (repro.sql): creates views t1/t2 over a UNION ALL (t2 with explicit column names)
and runs PRAGMA table_info on them (view-30.2), plus the CTE `IN` queries from view-31.1.
With the bug, the column type/collation is not taken from the leftmost SELECT of a compound
view, so table_info for t2 and the IN-over-CTE results differ from the clean shell.
