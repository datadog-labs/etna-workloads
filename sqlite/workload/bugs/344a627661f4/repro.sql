create table t(a,b,c);
PRAGMA hard_heap_limit=90000;
DROP TABLE IF EXISTS t1;
CREATE TABLE IF NOT EXISTS t1(a int,b float,primary key(a,b));
select 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30;
select * from t where a in (1,2,3,4,5,6,7,8,9,10,11,12);
