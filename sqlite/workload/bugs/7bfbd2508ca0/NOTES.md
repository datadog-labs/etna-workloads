Reproducer (repro.sql): the join8-14020 case. RIGHT JOIN followed by an INNER JOIN with WHERE terms on the last table.
Clean shell returns 4 rows (-|1|3, -|1|4, -|2|3, -|2|4). The buggy shell returns no rows, because the
planner (bFirstPastRJ removed in where.c) may reorder the table to the right of a RIGHT JOIN.
