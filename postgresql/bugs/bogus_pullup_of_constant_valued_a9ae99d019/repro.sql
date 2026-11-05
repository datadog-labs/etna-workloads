create type t2 as (a int8, b int8);
create function mk2(bigint, bigint) returns t2 as
$$select row($1,$2)::t2$$ language sql;
select * from mk2(1,2);
select * from coalesce(row(1)) as (a int, b int);
