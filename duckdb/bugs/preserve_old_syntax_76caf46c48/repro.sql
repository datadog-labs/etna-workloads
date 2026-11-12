CREATE SECRET scope_as_struct (TYPE HTTP, BEARER_TOKEN some_field, scope ('hi', 'hello'));
SELECT name, scope FROM duckdb_secrets();
