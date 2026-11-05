select has_column_privilege(9999,'nosuchcol','select');
create temp table mytable(f1 int, f2 int);
alter table mytable drop column f2;
select has_column_privilege('mytable','........pg.dropped.2........','select');
