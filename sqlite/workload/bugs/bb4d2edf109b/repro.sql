SELECT json_extract('{"A\"Key":1}', '$."A\"Key"');
SELECT JSON_SET('{}', '$."\"Key"', 1);
