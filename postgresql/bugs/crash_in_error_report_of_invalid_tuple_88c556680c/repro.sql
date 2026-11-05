begin;
declare c cursor for select distinct 1 from generate_series(1,2) for update;
rollback;
begin;
declare c cursor for select count(*) from generate_series(1,2) for share;
rollback;
