explain (verbose, costs off)
select row(row(row(1))) = any (select row(row(1)));
explain (costs off)
select x from (values (row(1, 2)), (row(1, 3))) _(x) union select x from (values (row(1, 2)), (row(1, 4))) _(x);
