repro.sql mirrors fts4growth-3.2: insert 8 docs (one segment each), delete two, then run
`merge=500,10` incremental merge, which produces the oldest segment in the index.
Clean shell drops the delete markers (end_block "320 208"); the buggy shell keeps them
(end_block "320 303"), because the FTS3_SEGMENT_IGNORE_EMPTY flag is no longer set.
