repro.sql: two tables t3(a), t4(x), each with a non-unique index, joined with `ORDER BY 1, 2` (orderby4-2.1).
Clean shell returns rows sorted: 1|3, 1|3, 1|4, 1|4. Buggy shell skips the needed sort and returns 1|3, 1|4, 1|3, 1|4.
