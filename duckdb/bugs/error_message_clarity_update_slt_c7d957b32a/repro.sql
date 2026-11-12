.mode list
.nullvalue NULL
CREATE OR REPLACE MACRO my_agg(x) AS SUM(CASE WHEN x THEN 1 END);
select my_agg(range) 
from range(2);
select my_agg(range) OVER () 
from range(2);
CREATE OR REPLACE MACRO my_func(x) AS mod(x, 2);
select my_func(range) 
from range(2);
select my_func(range) OVER () 
from range(2);
