# Rationale

Changed: `ext/fts3/fts3_write.c`, `fts3SegWriterAdd()`.

Reverses the fix hunk that added `if( pWriter->iFree==LARGEST_INT64 ) return FTS_CORRUPT_VTAB;`
before `fts3WriteSegment(p, pWriter->iFree++, ...)`. I deleted that line. Without it, a corrupt
%_segdir row whose leaf block id is LARGEST_INT64 makes `iFree++` overflow signed 64-bit
integers (undefined behaviour), and the write proceeds instead of reporting corruption.

The other hunks of the fix are not touched. The varint/u64 arithmetic hunks are already present in 3.54.1 and are not needed to bring this bug back.

Oracle: `fts3corrupt4-32.1` fails. It expects `1 {database disk image is malformed}` and gets a different result. It is the only failing case.
