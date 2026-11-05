CREATE TABLE bug_16784(i INT, j INT);
ANALYZE bug_16784;
ALTER TABLE bug_16784 SET (autovacuum_enabled = 'false');
UPDATE pg_class SET reltuples = 10 WHERE relname='bug_16784';
INSERT INTO bug_16784 SELECT g/10, g FROM generate_series(1,4000) g;
SET work_mem='64kB';
select v.a, count(*), sum(c) from
  (values (1),(2),(3)) v(a),
  lateral (select v.a, i, j, count(*) c from
             bug_16784 group by cube(i,j)) s
  group by v.a order by v.a;
