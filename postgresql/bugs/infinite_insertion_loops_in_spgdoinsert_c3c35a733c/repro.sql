set statement_timeout = '3s';
create table t(f1 text, f2 int, f3 text);
create index on t using spgist(f1) include(f2, f3);
\set VERBOSITY sqlstate
insert into t values(repeat('xyzzy', 12), 42, repeat('xyzzy', 4000));
