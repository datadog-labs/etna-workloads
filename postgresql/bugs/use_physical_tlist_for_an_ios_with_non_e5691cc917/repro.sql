create table gist_tbl (p point);
insert into gist_tbl select point(i,i) from generate_series(1,1000) i;
create index gist_tbl_multi_index on gist_tbl using gist (p, circle(p,1));
vacuum analyze gist_tbl;
set enable_seqscan=off; set enable_bitmapscan=off;
explain (verbose, costs off) select count(*) from gist_tbl;
select count(*) from gist_tbl;
