repro.sql loads the corrupt FTS3 database from fts3corrupt4-51.0 (via `.open --hexdb`) and runs the 51.1 query: `offsets(t1)` with a MATCH containing OR and NEAR.

Clean shell: `Error near line 212: database disk image is malformed`, exit status 1.
Buggy shell: no error. It returns a row (`xyzzy|0 1 92 6 0 0 120 6 0 2 120 6`), exit status 0.
