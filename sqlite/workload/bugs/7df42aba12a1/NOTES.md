repro.sh builds a 1024-byte-page db, then patches the file so freelist trunk page 3 lists
page 2 (t1's root) as a free leaf. An INSERT..SELECT scanning t1 (`a IN (1,2)`) inserts into
t2, which recycles page 2 while t1's cursor still holds it.
Clean: "database disk image is malformed" (detected by moveToRoot / allocateBtreePage).
Buggy: assertion failure in sqlite3PagerGetData (nRef>0), abort, exit 134.
