SELECT json_set('{"a":1}', '$."d"', 4);
SELECT json_insert('{"a":1}', '$."dd".x', 4);
