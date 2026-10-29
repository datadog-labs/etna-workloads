`repro.sql` loads the corrupt incremental-vacuum database from incrvacuum-17.0 with `.open --hexdb`. It then turns defensive mode off, because the shell turns it on by default and that would make `writable_schema` ineffective. It then runs `PRAGMA writable_schema=ON; PRAGMA incremental_vacuum(10);`.

The header claims 7 pages but the file has only 5. With `writable_schema` on, the clean shell clamps nPage to the file size, so the vacuum completes and prints `done`, exit status 0.

The buggy shell crashes with `Assertion 'pPager->dbSize>=nPage' failed` in `sqlite3PagerTruncateImage`, exit status 134 (SIGABRT).
