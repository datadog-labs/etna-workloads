Creates an fts5 trigram table and runs `SELECT 0 FROM t0(0) WHERE c0 GLOB 0` (a MATCH expression that is empty, combined via sqlite3Fts5ExprAnd with the GLOB-derived expression, where one side is NULL), then a `GLOB '*f*'` query (too short for a trigram, so empty expression).
Clean shell: exit 0, prints `assertionfaultproblem`. Buggy shell: crash (NULL p2 dereferenced in sqlite3Fts5ExprAnd).
