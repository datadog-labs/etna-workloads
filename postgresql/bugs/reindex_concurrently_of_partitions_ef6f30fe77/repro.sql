create table p (a int primary key) partition by range (a);
create table p1 partition of p for values from (0) to (10);
reindex index concurrently p1_pkey;
select relname, relispartition from pg_class where relname like 'p1%' order by 1;
select inhrelid::regclass, inhparent::regclass from pg_inherits where inhparent='p_pkey'::regclass;
alter table p detach partition p1;
select relname from pg_class where relname like 'p1%' order by 1;
\d p1
