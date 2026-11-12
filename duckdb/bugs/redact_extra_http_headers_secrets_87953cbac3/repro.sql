CREATE SECRET s (TYPE http, extra_http_headers MAP {'Authorization': 'Bearer abc'});
SELECT secret_string FROM duckdb_secrets() WHERE name='s';
