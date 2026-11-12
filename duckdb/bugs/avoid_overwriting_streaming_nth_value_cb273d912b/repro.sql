.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
PRAGMA explain_output = PHYSICAL_ONLY;
explain select nth_value(i, 1) over () 
from range(10) tbl(i);
explain select nth_value(i, 2) over (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
from range(5) tbl(i);
select nth_value(i, 2) over (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
from range(5) tbl(i);
explain select nth_value(i, -1) over (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
from range(5) tbl(i);
select nth_value(i, -1) over (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
from range(5) tbl(i);
SELECT s,
	nth_value(s, 2 IGNORE NULLS) over(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM (VALUES 
	(NULL), 
	('A'), 
	(NULL), 
	('B')
	) t(s);
WITH src(id, x) AS (VALUES (1, 10), (2, 20), (3, NULL), (4, 30))
SELECT id, NTH_VALUE(x, 2 IGNORE NULLS) OVER (
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS actual
FROM src ORDER BY id;
