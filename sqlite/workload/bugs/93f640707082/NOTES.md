repro.sql builds an FTS5 table with a tiny page size, then (defensive mode off) overwrites t1_data rows to make a
corrupt doclist-index (dlidx) chain 32 levels deep (fts5corrupt-5.0/5.1), and runs `t1 MATCH 'a AND x'`.

Clean shell: "database disk image is malformed", exit status 1.
Buggy shell: the missing nLvl check lets the query run on the corrupt index and return rows, exit status 0.
