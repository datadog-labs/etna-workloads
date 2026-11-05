create table t(a int, b int);
select has_column_privilege('t', 2::int2, 'select');
alter table t drop column b;
select has_column_privilege('t', 2::int2, 'select') is null as dropped_null;
select has_column_privilege('t', 99::int2, 'select') is null as missing_null;
