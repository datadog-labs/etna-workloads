create temp table nocolumns();
select exists(select * from nocolumns);
