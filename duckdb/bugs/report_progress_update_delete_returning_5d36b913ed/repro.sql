SET debug_verify_progress=ERROR;
CREATE TABLE modified AS SELECT range i FROM range(10000);
WITH u AS (UPDATE modified SET i = i + 1 RETURNING i) SELECT count(*) FROM u;
