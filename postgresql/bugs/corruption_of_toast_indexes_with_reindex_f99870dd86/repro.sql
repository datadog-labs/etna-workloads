create table t(id int, d text);
begin;
insert into t select 1, (select string_agg(md5(i::text),'') from generate_series(1,500) i);
select count(*) as toast_lock_held from pg_locks
 where mode = 'RowExclusiveLock'
 and relation = (select reltoastrelid from pg_class where relname='t');
commit;
