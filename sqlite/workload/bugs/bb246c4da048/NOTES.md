Builds a 6-page db (t1 on pages 2,5,6; 3,4 free), edits the freelist leaf entry to
page 6 so new table t4 gets root page 6 (also a t1 leaf), then runs
`INSERT INTO t4 SELECT x FROM t1 WHERE rowid>20`.
Clean shell: "database disk image is malformed" error. Buggy shell: assertion
`idx<=pPage->nCell` fails in btreeNext (abort, exit 134).
