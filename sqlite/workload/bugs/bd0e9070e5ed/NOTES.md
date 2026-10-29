repro.sh builds a 1024-byte-page WAL db, extends the file sparsely to 5000MB
(dd), zeroes the header page count (offset 28) so new pages are allocated past
4GiB, inserts more rows, closes (checkpoint) and reads back via both indexes.

Clean: prints `wal`, 16, 16. Buggy: "database disk image is malformed" — without
the i64 casts in walFrameOffset / the checkpoint write offset, offsets past 4GiB
overflow, so the pages are written to the wrong place.
