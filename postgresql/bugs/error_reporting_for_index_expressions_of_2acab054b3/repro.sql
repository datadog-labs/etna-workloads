create table t(f1 text, f2 text);
create index on t ((f1 || f2), (row(f1, f2)));
