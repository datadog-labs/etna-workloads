repro.sql builds an fts3 table, corrupts t1_segdir.start_block to 1 (start_block > end_block=0),
then runs the 'optimize' command. The buggy shell hits `assert( iStartLeaf<=iEndLeaf )` in
sqlite3Fts3SegReaderNew (assertion failure/abort); the clean shell completes normally (exit 0).
`.dbconfig defensive off` is needed so the shadow table can be modified.
