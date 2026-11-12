create table ck_sel_a as select range::integer x, (range % 10)::integer y from range(10000);
create table ck_sel_b as select range::integer x, (range % 10)::integer y from range(10000);
explain select count(*)
from ck_sel_a join ck_sel_b on ck_sel_a.x = ck_sel_b.x and ck_sel_a.y = ck_sel_b.y
where ck_sel_a.x < 100 and ck_sel_b.x < 100;
