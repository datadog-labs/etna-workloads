# Re-introducing: "pg_dump: Fix gzip compression of empty data" (00d9dcf5bebb)

REL_18_6 still has the post-fix structure (DeflateCompressorInit / DeflateCompressorEnd /
DeflateCompressorCommon, EndCompressorGzip only finalizing when `cs->private_data` is set).
The bug was that the deflate state was only created on the first Write call, so a compressor
that is Init'ed and End'ed without any Write (empty data, e.g. an empty large object) never
emits a zlib stream at all -> the archive contains an empty/invalid compressed member.

All changes are in `src/bin/pg_dump/compress_gzip.c`.

## Hunk 1 — `WriteDataToArchiveGzip()`
Traces to fix.patch hunk `@@ -106,41 +153,10 @@ WriteDataToArchiveGzip`, which removed the
`if (!gzipcs->zp) { ... deflateInit ... }` lazy-initialization block.  I restore the lazy
initialization: if `cs->private_data` is NULL, call `DeflateCompressorInit(cs)` on the first
Write (the same zlib setup code the old block contained, now living in DeflateCompressorInit).

## Hunk 2 — `InitCompressorGzip()`
Traces to fix.patch hunk `@@ -214,17 +230,19 @@ InitCompressorGzip`, which added
`if (cs->writeF) DeflateCompressorInit(cs);`.  Removing that call returns to deferring the
deflate initialization until Write.  Combined with EndCompressorGzip's existing
"only finalize if initialized" check (equivalent to the old `if (gzipcs->zp)`), an Init→End
sequence with no Write writes no zlib stream (no header, no Z_FINISH trailer).  On restore,
ReadDataFromArchiveGzip gets no input and inflate() fails:
`pg_restore: error: could not uncompress data: (null)`.

## Failing oracle cases
10203 of 13808 cases fail. The root failures are
- `src/bin/pg_dump|t/002_pg_dump.pl|compression_gzip_custom: pg_restore runs`
- `src/bin/pg_dump|t/002_pg_dump.pl|defaults_custom_format: pg_restore runs`
(both are gzip-compressed custom archives containing the empty large object from the
"LO create (with no data)" test), followed by the cascade of `should dump` / `should not dump`
checks for those runs and the later runs in 002_pg_dump.pl (reported as fail/missing).
Full list: `failing_cases.txt`.


<!-- produced on retry with opus -->
