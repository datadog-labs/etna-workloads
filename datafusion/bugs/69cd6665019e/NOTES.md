repro.sql builds a table whose columns carry Arrow field metadata (via `with_metadata`), then runs
`SELECT name FROM (SELECT id, name FROM t UNION ALL SELECT NULL::int, NULL::string) GROUP BY name ORDER BY name`.
Clean: returns a, b, NULL. Buggy: `Internal error: Physical input schema should be the same as the one
converted from logical input schema` (field metadata {"k":"v"} physical vs {} logical), because
intersect_metadata_for_union lets the NULL-literal branch's empty metadata wipe the other branch's metadata
once projection pruning recomputes the Union schema.
