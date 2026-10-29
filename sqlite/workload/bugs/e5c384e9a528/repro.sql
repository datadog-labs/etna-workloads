SELECT json(jsonb_insert('{"a":2,"c":4}', '$.a', 99));
