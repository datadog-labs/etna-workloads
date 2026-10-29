Loads the corrupt FTS3 database from fts3corrupt4 test 10.0 via `.open --hexdb`, runs the INSERT from 10.1, then `INSERT INTO t1(t1) VALUES('optimize')` (10.3).

clean: "database disk image is malformed" (exit 1).
buggy: the missing `iEndLeaf!=0` corruption check in sqlite3Fts3SegReaderNew lets the corrupt segment through, so the error is not reported and the debug build prints "Memory leaked: 4080 bytes" (exit 0).
