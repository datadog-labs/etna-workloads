# Bug #3918: free-list leaf extraction from an empty trunk

Fix hunk reversed: `src/btree.c` allocateBtreePage(), `}else{` -> `}else if( k>0 ){`
before "Extract a leaf from the trunk". The other fix hunks only touch TRACE
macros (not behaviour) and manifest files.

In 3.54.1 the same branch exists at the same position (`src/btree.c` ~line 6720),
so I restored the pre-fix `}else{`. With a trunk holding zero leaves (k==0) that
is being searched (incremental vacuum, nearby != trunk), the code now reads
leaf slot 0 (garbage / the next-trunk area), and reports SQLITE_CORRUPT.

Oracle: test/tkt3918.test case tkt3918.5 (CREATE TABLE t2 after incremental
vacuum) fails with "database disk image is malformed", exactly the symptom the
fix describes. Cases .1-.4 pass.
