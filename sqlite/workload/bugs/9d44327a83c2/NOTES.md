repro.sql builds a corrupt fts3 table (two hand-written t1_segdir rows, as in fts3corrupt4-47.2) and runs matchinfo() with a phrase MATCH.
Clean: "database disk image is malformed" (exit 1). Buggy: assertion `pRoot->bEof==0' fails in fts3EvalGatherStats (abort, exit -6).
