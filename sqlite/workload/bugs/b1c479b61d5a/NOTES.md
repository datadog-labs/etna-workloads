repro.sql builds an fts3 table, writes two corrupt t1_segdir rows (defensive mode off), then runs matchinfo() with a prefix MATCH query (test fts3corrupt4-31).
Clean shell: "database disk image is malformed" (exit 1). Buggy shell: assertion failure in fts3PutDeltaVarint3 (`iWrite>=0`), abort (exit -6).
