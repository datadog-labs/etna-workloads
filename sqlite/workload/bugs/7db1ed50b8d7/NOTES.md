Reproducer: repro.sql loads the corrupt fts3 database from test fts3corrupt4-45.0 (via `.open --hexdb`) and runs `INSERT INTO x1(x1) VALUES('merge=1')`.
Clean shell: "Error near line 93: database disk image is malformed", exit 1.
Buggy shell: the nHeight>FTS_MAX_APPENDABLE_HEIGHT check lets height==max through, so it crashes (SIGSEGV, status -11).
