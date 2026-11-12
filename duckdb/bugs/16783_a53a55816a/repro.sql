.mode list
.nullvalue NULL
CREATE TABLE t0(c0 FLOAT);
CREATE TABLE t1(c0 FLOAT);
select * from t0
where not exists(
    select 1 from t1 where (((((t0.c0) AND ((t1.c0 BETWEEN t0.c0 AND t0.c0)))) OR (((t0.c0) AND ((t1.c0 BETWEEN t0.c0 AND t0.c0))))))
);
