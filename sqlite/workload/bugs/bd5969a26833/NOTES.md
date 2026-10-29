repro.sh builds the corrupt-4.x database (page_size 1024, t1 with 10 rows of 220 chars, index i1), overwrites the left-child pointer of the first cell on i1's root page with the page number of t1's root (an intkey b-tree), then runs `DELETE FROM t1 WHERE rowid=3`.

Clean: "database disk image is malformed" (exit 1). Buggy: assertion `pPage->intKey==0` fails in sqlite3BtreeIndexMoveto and the shell aborts (exit 134), because moveToChild no longer checks that the child's intKey matches its parent.
