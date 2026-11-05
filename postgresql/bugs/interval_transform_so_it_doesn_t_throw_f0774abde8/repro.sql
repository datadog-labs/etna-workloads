create temp table t(m interval month, s interval second);
insert into t values ('14 months', '1 day 2 min 3 sec');
select m::interval year, s::interval minute from t;
explain (verbose, costs off) select m::interval year, s::interval minute from t;
