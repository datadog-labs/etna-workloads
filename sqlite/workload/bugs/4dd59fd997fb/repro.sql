SELECT json_insert('{}','$.a',value) FROM json_tree('[1,2,3]') WHERE atom IS NULL;
