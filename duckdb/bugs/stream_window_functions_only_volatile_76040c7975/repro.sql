.mode list
.nullvalue NULL
SET threads=1;
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
PRAGMA explain_output = PHYSICAL_ONLY;
CREATE SEQUENCE lead_seq START 1;
SELECT min(x), max(x), sum(x), count(*)
FROM (
	SELECT LEAD(nextval('lead_seq'), 1, -1) OVER () AS x
	FROM range(5000)
);
