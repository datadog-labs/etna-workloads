repro.sql builds an fts3 table, injects a corrupt segment into t1_segdir (needs `.dbconfig defensive off`), then runs the fts3corrupt4-41.2 phrase query.
Clean shell: exits 0 with no query output. Buggy shell: aborts (status -6) on assertion `p!=0 && *p1!=0 && *p2!=0` in fts3PoslistPhraseMerge (the fix turned it into assert_fts3_nc).
