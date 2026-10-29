Reproducer: repro.sql loads the corrupt FTS5 database from fts5corrupt3-74.0 (via `.open --hexdb`) and runs the prefix query `t1 MATCH 'e*'`.
Clean shell: query returns rows (exit 0). Buggy shell: assertion failure in fts5MergePrefixLists
(`nSpace>=n+nPoslist+nSize`), exit 134 — the buffer overrun in fts5DoclistIterNext when a poslist runs past aEof.
