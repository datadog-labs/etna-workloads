create table coercepart (a text) partition by list (a);
create table coercepart_ab partition of coercepart for values in ('ab');
create table coercepart_bc partition of coercepart for values in ('bc');
explain (costs off) select * from coercepart where a = any (null::text[]);
