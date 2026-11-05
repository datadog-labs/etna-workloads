create table y (a int);
create rule y_rule as on insert to y do instead notify foo;
with t as (insert into y values(0)) values(false);
