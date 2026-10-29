repro.sql builds the fts5faultD table (detail=full, tiny pages), then truncates one
segment-leaf row in o1_data (defensive mode off) so a read fails mid-iteration while
evaluating `{b c}:b AND a:a`. The error path leaves a stale pNode->bNomatch=1.
clean: "database disk image is malformed", exit 1.
buggy: assertion failure in sqlite3Fts5ExprNext (pRoot->bNomatch==0 || ...), abort, exit 134.
(Stands in for the test's sqlite3_interrupt/fault injection, which has no shell equivalent.)
