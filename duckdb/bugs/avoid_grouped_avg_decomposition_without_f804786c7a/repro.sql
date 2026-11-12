.mode list
.nullvalue NULL
CREATE TABLE avg_inputs(g INTEGER, x INTEGER, y INTEGER, d DECIMAL(12,2));
INSERT INTO avg_inputs VALUES (1,10,100,1.5),(1,NULL,200,NULL),(1,20,NULL,3.5),(2,NULL,NULL,NULL),(2,NULL,400,NULL);
PRAGMA explain_output='optimized_only';
EXPLAIN SELECT g, avg(x) AS a0 FROM avg_inputs GROUP BY g;
