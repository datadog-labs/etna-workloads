CREATE TABLE t1 (c1);
INSERT INTO t1 VALUES (101);
CREATE TABLE t2 ( x );
INSERT INTO t2 VALUES(404);
select * from t2
  where 'val' in (
      select 'val' from ( select 'valueB' from t1 order by 1 )
      union all
      select 'val'
  );
