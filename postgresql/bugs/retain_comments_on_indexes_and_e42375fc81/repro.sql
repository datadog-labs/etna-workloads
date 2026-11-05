create table ct(id int, t text, constraint ct_pk primary key (id), constraint ct_u unique (t));
create index ct_i on ct(id);
comment on index ct_i is 'idx';
comment on constraint ct_pk on ct is 'pk con';
comment on index ct_pk is 'pk idx';
alter table ct alter column id type bigint;
select indexrelid::regclass::text, obj_description(indexrelid,'pg_class') from pg_index where indrelid='ct'::regclass order by 1;
select conname, obj_description(oid,'pg_constraint') from pg_constraint where conrelid='ct'::regclass order by 1;
