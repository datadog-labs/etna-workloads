begin;
create table numeric_tbl (f1 numeric(18,3), f2 numeric);
create view numeric_view as select f1::numeric as f1n from numeric_tbl;
\d+ numeric_view
rollback;
