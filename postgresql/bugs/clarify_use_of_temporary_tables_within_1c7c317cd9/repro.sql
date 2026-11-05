create table perm_parted (a int) partition by list (a);
create temp table temp_part partition of perm_parted default;
create table perm_p2 (a int) partition by list (a);
create temp table temp_child (a int);
alter table perm_p2 attach partition temp_child default;
select count(*) from pg_inherits;
