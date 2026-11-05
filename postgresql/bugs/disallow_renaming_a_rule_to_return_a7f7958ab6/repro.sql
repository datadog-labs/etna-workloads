create table t(a int);
create rule r1 as on insert to t do also notify foo;
alter rule r1 on t rename to "_RETURN";
select rulename from pg_rules where tablename='t';
