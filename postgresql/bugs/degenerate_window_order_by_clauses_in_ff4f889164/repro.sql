select sum(1) over (groups between unbounded preceding and current row) from generate_series(1,3);
