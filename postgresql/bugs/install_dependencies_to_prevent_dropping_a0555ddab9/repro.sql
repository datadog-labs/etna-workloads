create domain intdom1 as int;
create table partitioned (a intdom1, b text) partition by range (a);
drop domain intdom1 cascade;
select count(*) from pg_class where relname='partitioned';
