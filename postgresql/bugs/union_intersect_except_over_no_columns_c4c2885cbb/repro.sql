select union select;
select intersect select;
select except select;
select from generate_series(1,5) union select from generate_series(1,3);
select from generate_series(1,5) intersect select from generate_series(1,3);
select from generate_series(1,5) except select from generate_series(1,3);
