create table bp (a bool) partition by list (a);
create table bp_f partition of bp for values in (false);
create table bp_t partition of bp for values in (true);
create table bp_n partition of bp for values in (null);
insert into bp values (true),(false),(null);
select * from bp where a is not true order by a;
select * from bp where a is not false order by a;
