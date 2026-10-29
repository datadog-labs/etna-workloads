# Rationale

## Change
`tree/ext/fts3/fts3.c`, `fts3PutDeltaVarint3()`: the line
`assert_fts3_nc( *pbFirst==0 || iWrite>0 );` is turned back into a hard
`assert( *pbFirst==0 || iWrite>0 );`.

This reverses the fix hunk, which replaced that hard assert with
`assert_fts3_nc(...)` (the corruption-tolerant variant) and added
`assert( *pbFirst==0 || iWrite>=0 )`. In 3.54.1 `iWrite` is a `u64`, so the
`>=0` assert is always true and has no effect. Putting the hard `>0` assert back
restores the pre-fix state, where a delta of 0 (possible when the database is
corrupt) aborts a debug build.

## Oracle
`fts3corrupt4-30.2` (`matchinfo` on the corrupt db from test 30.0) dies with
`Assertion '*pbFirst==0 || iWrite>0' failed` in `fts3PutDeltaVarint3`. The test
expects `database disk image is malformed`.
