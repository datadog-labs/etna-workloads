.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
PRAGMA explain_output = PHYSICAL_ONLY;
EXPLAIN
SELECT i, LAG(i, 1) OVER() AS i1
FROM range(10) tbl(i);
SELECT i, LAG(i, 1) OVER() AS i1
FROM range(10) tbl(i);
EXPLAIN
SELECT i, LAG(i, -1) OVER() AS i1
FROM range(10) tbl(i);
SELECT i, LAG(i, -1) OVER() AS i1
FROM range(10) tbl(i);
EXPLAIN
SELECT i, LEAD(i, -1) OVER() AS i1
FROM range(10) tbl(i);
SELECT i, LEAD(i, -1) OVER() AS i1
FROM range(10) tbl(i);
EXPLAIN
SELECT i, LEAD(i, 1) OVER() AS i1
FROM range(10) tbl(i);
SELECT i, LEAD(i, 1) OVER() AS i1
FROM range(10) tbl(i);
EXPLAIN
SELECT i, LAG(i, 1) OVER() AS i1
FROM range(3000) tbl(i)
WHERE i % 2 = 0
QUALIFY i1 <> i - 2;
SELECT i, LAG(i, 1) OVER() AS i1
FROM range(3000) tbl(i)
WHERE i % 2 = 0
QUALIFY i1 <> i - 2;
EXPLAIN
SELECT i, LAG(i, 1, 50) OVER() AS i1
FROM range(10) tbl(i);
SELECT i, LAG(i, 1, 50) OVER() AS i1
FROM range(10) tbl(i);
EXPLAIN
SELECT i, LEAD(i, 1, 50) OVER() AS i1
FROM range(10) tbl(i);
SELECT i, LEAD(i, 1, 50) OVER() AS i1
FROM range(10) tbl(i);
EXPLAIN
SELECT i, LEAD(i, 2) OVER() AS i1
FROM range(3000) tbl(i)
WHERE i % 2048 = 0;
SELECT i, LEAD(i, 2) OVER() AS i1
FROM range(3000) tbl(i)
WHERE i % 2048 = 0;
EXPLAIN
SELECT i, LEAD(i, 2) OVER() AS i1
FROM range(5000) tbl(i)
WHERE i % 2048 = 0;
SELECT i, LEAD(i, 2) OVER() AS i1
FROM range(5000) tbl(i)
WHERE i % 2048 = 0;
EXPLAIN
SELECT i, LAG(i, 3000) OVER() AS i1
FROM range(5000) tbl(i);
EXPLAIN
SELECT i, LEAD(i, 3000) OVER() AS i1
FROM range(5000) tbl(i);
SELECT i, LEAD(i, 1) OVER(), LEAD(i, 2) OVER()
FROM range(10) tbl(i);
select * from (
	select 
		id, 
		lead(id, 2047, -1) over() l 
	from range(6144) tbl(id)
	where id != 1 
	  and id != 2 
	  and id != 2500 
	  and id != 2501 
	  and id != 2502
) 
where id >= 2040 and id <= 2050;
SELECT LAG ( v3 , 10 , 3 ) OVER( ) 
FROM VALUES 
	( 0 , 1::VARCHAR , 1 ),
	( 1 , NULL , 2 )
	AS v0(v1, v3, v2);
SELECT LEAD(i, (-9223372036854775808)::BIGINT) OVER () FROM range(3) t(i);
SELECT LAG(i, (-9223372036854775808)::BIGINT) OVER () FROM range(3) t(i);
WITH t AS (
	SELECT range AS i FROM range(3) 
	UNION ALL 
	SELECT range AS i FROM range(3)
)
SELECT i, lead(i, 1) OVER () AS next_i
FROM t;
