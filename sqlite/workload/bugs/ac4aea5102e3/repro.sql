SELECT json_insert('{"a":1}','$.b',CAST(x'0000' AS text));
