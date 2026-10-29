repro.sql: `SELECT typeof(replace(1,'',0))`.
Clean returns text; buggy returns integer (replace returns argv[0] unchanged when the pattern is empty).
