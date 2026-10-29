.open test.db
PRAGMA journal_mode=wal;
CREATE TABLE t(x);
INSERT INTO t VALUES(1);
.dbconfig no_ckpt_on_close on
PRAGMA journal_mode=delete;
.shell ls test.db*
