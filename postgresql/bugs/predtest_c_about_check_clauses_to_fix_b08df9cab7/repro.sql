create table rp (a int) partition by range (a);
create table rp1 partition of rp (check (a>=123 and a<133 and a is not null)) for values from (100) to (200);
alter table rp detach partition rp1 concurrently;
\d rp1
