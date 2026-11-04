select corr(sq.column1, sq.column2) from (values (1.1, 2.2)) as sq;
select corr(x, y) from (values (1.0, 2.0), (1.0, 3.0)) as t(x, y);
