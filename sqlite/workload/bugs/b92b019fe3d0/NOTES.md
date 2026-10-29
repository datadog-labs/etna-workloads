repro.sql loads the corrupt database from test 49.0 via `.open --hexdb` and runs the query from 49.1 (`SELECT term FROM t4 WHERE term LIKE 'oase'`, an fts5vocab table over a corrupt fts5 index).

Clean shell: `database disk image is malformed`. Buggy shell: `out of memory`. The removed `nNew==0` check lets a zero-length term through, which gives a wrong error here.
