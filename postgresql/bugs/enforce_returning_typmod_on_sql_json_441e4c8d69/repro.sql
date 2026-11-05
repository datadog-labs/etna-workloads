SELECT JSON_VALUE(jsonb '{}', '$.a' RETURNING numeric(4,1) DEFAULT 99999.999 ON EMPTY);
SELECT JSON_VALUE(jsonb '{}', '$.a' RETURNING varchar(3) DEFAULT 'toolong'::varchar(10) ON EMPTY);
