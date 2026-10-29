repro.sql creates an index on the expression nullif(json(y),8), then selects
json_insert('{}','$.a',nullif(json(y),8))->>'$.a.b'.
Clean shell prints `5`. Buggy shell prints an empty line (NULL), because the
subtype-dependent expression is wrongly replaced by the indexed column value,
which has lost its JSON subtype.
