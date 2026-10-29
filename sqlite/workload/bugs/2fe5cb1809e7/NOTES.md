repro.sql creates an FTS3 table, inserts one row, and runs `MATCH '""'` (an empty phrase).
Clean shell: returns no rows, exit 0.
Buggy shell: the empty phrase node never gets eType=FTSQUERY_PHRASE, so freeing it trips the assertion `p->eType==FTSQUERY_PHRASE || p->pPhrase==0` in fts3FreeExprNode, and the shell aborts (exit -6).
