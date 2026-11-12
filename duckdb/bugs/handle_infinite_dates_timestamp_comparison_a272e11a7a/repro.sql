.mode list
.nullvalue NULL
create table ts_inf(t timestamp);
insert into ts_inf values (timestamp '-infinity'), (timestamp '2025-01-01'), (timestamp 'infinity'), (NULL);
select count(*) from ts_inf where cast(t as date) = date 'infinity';
