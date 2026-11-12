PREPARE p AS COPY (SELECT 1) TO 'x.csv' (FORMAT csv);
SELECT statement FROM duckdb_prepared_statements();
