SELECT ROW_NUMBER() OVER () AS rn FROM read_duckdb('data/storage/block_size_16kb.db', table_name='tbl') ORDER BY rn LIMIT 3;
