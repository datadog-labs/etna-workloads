create table target_parted (a int, b int) partition by list (a);
create table attach_parted (a int, b int) partition by list (b);
create table attach_parted_part1 partition of attach_parted for values in (1);
insert into attach_parted_part1 values (1, 1);
alter table target_parted attach partition attach_parted for values in (1);
insert into attach_parted_part1 values (2, 1);
alter table target_parted detach partition attach_parted;
insert into attach_parted_part1 values (2, 1);
