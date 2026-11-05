SELECT JSON_VALUE(jsonb '"aaa"', '$' RETURNING char(5) DEFAULT 'abcdefgh' ON ERROR);
SELECT JSON_VALUE(jsonb '1', '$.a' RETURNING char(3) DEFAULT 'abcdefgh' ON EMPTY);
SELECT JSON_VALUE(jsonb '1', '$.a' RETURNING char(3) DEFAULT 'abc' ON EMPTY);
SELECT * FROM JSON_TABLE(jsonb '1', '$' COLUMNS (a char(2) EXISTS PATH '$.a'));
SELECT JSON_QUERY(jsonb '1', '$.a' RETURNING bit(3) DEFAULT '1' ON EMPTY);
