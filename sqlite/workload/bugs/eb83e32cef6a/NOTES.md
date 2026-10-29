Reproducer (repro.sh) mirrors fts5corruptA-2.2: builds an fts5 table with terms aaaa/bbbb/cccc,
then overwrites the leaf's "\x01\x04cccc" (nKeep=1,nNew=4) with "\x01\x7fcccc" so the
term suffix length runs past the end of the page, and runs a MATCH query for a long c-string.
Clean shell: `fts5: corruption on page 1, segment 1, table "t1"` (exit 1).
Buggy shell: the missing bounds check in fts5LeafSeek lets the query return silently, no error (exit 0).
