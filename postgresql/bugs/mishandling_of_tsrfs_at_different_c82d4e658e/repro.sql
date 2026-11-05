explain (verbose, costs off) select generate_series(1,3) as x, generate_series(3,6) + 1 as y;
explain (verbose, costs off) select generate_series(1, generate_series(1, 3)), generate_series(2, 4);
select generate_series(1, generate_series(1, 3)), generate_series(2, 4);
