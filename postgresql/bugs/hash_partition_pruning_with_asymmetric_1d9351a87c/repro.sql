create table hp (a int, b text) partition by hash (a);
create table hp0 partition of hp for values with (modulus 4, remainder 0);
create table hp3 partition of hp for values with (modulus 4, remainder 3);
insert into hp select i, 'x' from generate_series(1,20) i;
explain (costs off) select * from hp where a = 1 or b = 'x';
select count(*) from hp where b = 'x' or a = 1;
