create table foo (a varchar, b varchar) as values ('a', 'b');
SELECT concat_ws('',a,b,'c') from foo;
EXPLAIN SELECT concat_ws('',a,b,'c') from foo;
