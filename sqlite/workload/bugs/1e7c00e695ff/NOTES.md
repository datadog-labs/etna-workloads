Reproducer for the xferCompatibleIndex() bug (ticket 302027baf1374498): in a WITHOUT ROWID table with
PRIMARY KEY(c1,c1) and UNIQUE c1, `INSERT INTO t1 SELECT * FROM t0` uses the xfer optimization
and mis-copies index entries. See the shell outputs from ./check.sh for the difference
(integrity_check / SELECT result differ between clean and buggy).
