Reproducer (repro.sql) is the orderby5-4.4.0 case: a DISTINCT query over a LEFT JOIN whose ON clause has `b=(SELECT a FROM t1)` on an INTEGER PRIMARY KEY.
Clean shell: no output, exit 0. Buggy shell: assertion failure `pColl1 && (pParse->nErr || pColl2)` in wherePathSatisfiesOrderBy, abort (exit 134).
