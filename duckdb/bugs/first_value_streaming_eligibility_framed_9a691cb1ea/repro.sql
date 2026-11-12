.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
PRAGMA explain_output = PHYSICAL_ONLY;
create table integers (i int, j int);
insert into integers values (2, 2), (2, 1), (1, 2), (1, NULL);
EXPLAIN
SELECT i, COUNT(*) OVER() FROM integers;
EXPLAIN
SELECT i, SUM(i) OVER() FROM integers;
EXPLAIN
SELECT j, COUNT(j) FILTER(WHERE i = 2) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
EXPLAIN
SELECT j, COUNT(*) FILTER(WHERE i = 2) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
EXPLAIN
SELECT j, SUM(j) FILTER(WHERE i = 2) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
explain select row_number() over (), i, j from integers;
select row_number() over (), i, j from integers;
explain select row_number() over (), i, j from integers where i>1;
select row_number() over (), i, j from integers where i>1;
explain select rank() over (), i, j from integers;
select rank() over (), i, j from integers;
explain select dense_rank() over (), i, j from integers;
select dense_rank() over (), i, j from integers;
explain select percent_rank() over (), i, j from integers;
select percent_rank() over (), i, j from integers;
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
SELECT i, COUNT(*) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
SELECT i, COUNT(*) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
EXPLAIN
SELECT i, COUNT(*) FILTER(WHERE i = 2) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
SELECT i, COUNT(*) FILTER(WHERE i = 2) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
EXPLAIN
SELECT j, COUNT(j) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
SELECT j, COUNT(j) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
EXPLAIN
SELECT i, SUM(i) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
EXPLAIN
SELECT i, SUM(i) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
SELECT i, SUM(i) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM integers;
EXPLAIN
SELECT SUM(s) FROM (
	SELECT SUM(i) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s
	FROM range(5000) tbl(i)
);
SELECT SUM(s) FROM (
	SELECT SUM(i) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s
	FROM range(5000) tbl(i)
);
explain select i, j, first_value(i) over (), first_value(j) over () from integers;
EXPLAIN
SELECT first_value(i) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM integers;
select i, j, first_value(i) over (), first_value(j) over () from integers;
select row_number() over (), first_value(i) over (), first_value(j) over () from integers;
EXPLAIN
SELECT first_value(i) OVER (ROWS BETWEEN CURRENT ROW AND CURRENT ROW)
FROM range(4) t(i);
