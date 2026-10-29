`repro.sql` creates t1 and self-joins it without aliases (`t1 JOIN t1 USING (a)` and `t1 NATURAL JOIN t1`).

- Clean: the generated join term refers to each table by its FROM-list position, so the rows are matched one to one: `1 2` and `1|abc 2|def`.
- Buggy: the term refers to the tables by name. Both sides resolve to the same table, so the join condition doesn't relate the two copies. Each row comes out twice (cross product): `1 1 2 2` and `1|abc 1|abc 2|def 2|def`.
