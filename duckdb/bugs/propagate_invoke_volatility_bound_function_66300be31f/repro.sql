.mode list
.nullvalue NULL
select invoke(lambda x: x * x, 2) as square_of_x;
CREATE SEQUENCE invoke_cse_seq START 1;
SELECT count(*) FILTER (WHERE a = b), count(*)
FROM (
	SELECT
		invoke(lambda x: nextval('invoke_cse_seq'), i) a,
		invoke(lambda x: nextval('invoke_cse_seq'), i) b
	FROM range(10000) tbl(i)
);
CREATE SEQUENCE invoke_constant_seq START 1;
SELECT count(DISTINCT invoke(lambda x: nextval('invoke_constant_seq'), 1)) FROM range(10000);
