create type comptype as (r float8, i float8);
create domain dcomptype as comptype;
alter domain dcomptype add constraint c1 check ((value).r > 0);
comment on constraint c1 on domain dcomptype is 'random commentary';
alter type comptype alter attribute r type bigint;
alter type comptype drop attribute i;
select conname, obj_description(oid, 'pg_constraint') from pg_constraint
  where contypid = 'dcomptype'::regtype;
drop type comptype cascade;
