.mode list
.nullvalue NULL
SET VARIABLE wide_struct_sql = (
    SELECT 'SELECT (NULL::STRUCT(' || string_agg('c' || i || ' INTEGER', ',') || ')) IS NULL'
    FROM range(1500) t(i)
);
FROM query(getvariable('wide_struct_sql'));
