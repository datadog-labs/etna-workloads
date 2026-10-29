repro.sql builds an fts3 table, corrupts the root node in t1_segdir (the term length byte is set to 24, so the term runs past the end of the node), inserts 15 more rows, then inserts 'world'.
Clean shell: the last INSERT fails with "database disk image is malformed" (exit 1).
Buggy shell: the corruption check is missing, so the INSERT succeeds silently (exit 0).
`.dbconfig defensive off` is needed so the shadow table can be updated.
