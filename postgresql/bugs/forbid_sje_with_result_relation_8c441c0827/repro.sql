create table sj(a int unique, b int);
explain (costs off) update sj sq set b = 1 from sj sz where sq.a = sz.a;
