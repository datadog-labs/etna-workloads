create type jpop as (f1 int, f2 int);
SELECT i, json_populate_recordset(row(i,50), '[{"f1":"42"},{"f2":"43"}]') FROM (VALUES (1),(2)) v(i);
SELECT i, jsonb_populate_recordset(row(i,50), '[{"f1":"42"},{"f2":"43"}]') FROM (VALUES (1),(2)) v(i);
