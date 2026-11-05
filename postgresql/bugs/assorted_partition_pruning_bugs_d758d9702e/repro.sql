create table coercepart (a varchar) partition by list (a);
create table coercepart_ab partition of coercepart for values in ('ab');
create table coercepart_bc partition of coercepart for values in ('bc');
create table coercepart_cd partition of coercepart for values in ('cd');
explain (costs off) select * from coercepart where a in ('ab', to_char(125, '999'));
explain (costs off) select * from coercepart where a ~ any ('{ab}');
explain (costs off) select * from coercepart where a !~ all ('{ab,bc}');
