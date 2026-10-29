repro.sql: builds an fts4 table, replaces its segdir with a crafted root node whose
fts4aux doclist has a column number of 0x7FFFFFFF (turned off defensive mode to edit shadow tables),
then runs `SELECT * FROM t1_terms` (fts4aux).
Clean: "database disk image is malformed". Buggy (column bound check loosened to 0x3fffffff
in fts3_aux.c): "out of memory". Both exit status 1.
