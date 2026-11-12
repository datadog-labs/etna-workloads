.mode list
.nullvalue NULL
SET order_by_non_integer_literal=true;
SELECT DISTINCT ON ('string') 'x' AS c02;
