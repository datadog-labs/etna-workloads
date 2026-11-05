create collation ci (provider = icu, locale = 'und-u-ks-level2', deterministic = false);
create table t (a text collate ci);
insert into t values ('a'),('A');
explain (costs off) select a, count(*) from t group by a having a = 'a' collate "C";
select count(*) from t group by a having a = 'a' collate "C";
