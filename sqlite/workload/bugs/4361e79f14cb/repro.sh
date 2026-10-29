#!/bin/bash
# Reproducer for corrupt-6.1 / corrupt-8.x: a freeblock on a btree page
# whose size field makes it extend past the end of the usable page data.
# The fix (btree.c, 2009-08-14) added a check that the freeblock's last
# byte lies within the page; without it, later cell-allocation code can
# write past the end of the in-memory page buffer.
set -e

"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
CREATE TABLE t1(x);
WITH RECURSIVE c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<63)
INSERT INTO t1 SELECT randomblob(10) FROM c;
DELETE FROM t1 WHERE rowid=1;
SQL

# t1's root page is page 2 (1024 bytes). Deleting rowid=1 (the cell at the
# end of the page, offset pgsz-14) turns it into a freeblock. Corrupt that
# freeblock's size field (at offset+2) to 0x00FF, so size=255 runs off
# the end of the page.
rootpage_offset=$((2*1024 - 14 + 2))
printf '\x00\xff' | dd of=test.db bs=1 seek="$rootpage_offset" conv=notrunc status=none

"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
INSERT INTO t1 VALUES(randomblob(10));
SQL
