# Rationale

Fix hunk (src/select.c, count(*) optimization in sqlite3Select) added `pIdx->pPartIdxWhere==0`
to the index-selection loop so partial indexes are never used to count rows.

In 3.54.1 the loop is the same logic (with szIdxRow instead of nColumn). I removed the
`&& pIdx->pPartIdxWhere==0` condition at src/select.c (~line 8961), restoring the pre-fix
behaviour: a partial index can be chosen as the smallest index, so count(*) counts only its rows.

Oracle: index6-1.1.1 (`SELECT count(*) FROM t1` expected 20) fails, returning the partial index's row count.
