select to_tsquery('english', 'pg_class <-> pg');
select websearch_to_tsquery('english', '"pg_class pg"');
select websearch_to_tsquery('simple', 'fat-rat');
select to_tsvector('simple','pg_class pg') @@ websearch_to_tsquery('simple','"pg_class pg"');
