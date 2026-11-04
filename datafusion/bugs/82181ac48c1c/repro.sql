PREPARE my_plan AS SELECT a, b FROM (VALUES ($1, $2)) AS t(a, b);
EXECUTE my_plan(1, 2);
DEALLOCATE my_plan;
