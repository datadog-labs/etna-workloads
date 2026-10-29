repro.sql: FTS5 trigram table with a Cyrillic row, queried with GLOB '*ир*' (a 2-character, 4-byte run).
Clean shell returns 20. Buggy shell counts bytes rather than characters, so the run is treated as >=3 chars and it returns the wrong result (see ./check.sh output).
