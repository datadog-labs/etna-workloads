repro.sql: LEFT JOIN whose ON clause wraps a term in likely(). Without the fix, setJoinExpr does not
recurse into function arguments, so the likely() term is treated as a WHERE term and the LEFT JOIN
rows are dropped. Clean shell prints 4; buggy prints 1 (wrong count).
