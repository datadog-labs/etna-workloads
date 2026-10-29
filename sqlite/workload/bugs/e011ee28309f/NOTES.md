repro.sql loads the corrupt FTS3 database from test fts3corrupt4-11.1 via `.open --hexdb`, then runs
`SELECT rowid, quote(matchinfo(t1,'pcxybs')) FROM t1 WHERE t1 MATCH 'e*'`.
Clean shell: returns some rows, then "database disk image is malformed" (exit 1).
Buggy shell: assertion failure `0` in fts3LcsIteratorAdvance (abort, exit -6), because fts3MatchinfoLcs no longer reports corruption.
