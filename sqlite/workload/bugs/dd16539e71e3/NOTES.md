repro.sql runs the join-31.2/31.3 queries: a RIGHT JOIN whose left table has a NOT NULL column, followed by LEFT JOIN ... USING(c0) / NATURAL.
Clean shell returns `NULL|3|NULL` for both queries. The buggy shell returns `NULL|3|11`, because EP_CanBeNull is not set on the synthesized ON term. The NULL c0 then wrongly matches t1's NULL c0 row.
