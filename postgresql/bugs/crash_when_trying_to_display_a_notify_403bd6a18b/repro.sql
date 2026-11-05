create table rs(f1 int);
create rule r3 as on delete to rs do notify rs_del;
\d+ rs
select pg_get_ruledef(oid) from pg_rewrite where rulename='r3';
