# Rationale

File/function: src/bin/pg_basebackup/pg_basebackup.c, BaseBackup() (the includewal == STREAM_WAL block that chooses wal_compress_algorithm/level; in current code the logic that was in LogStreamerMain moved here).

Traces to the single fix.patch hunk, which changed `(compresslevel > 0)` to `(compresslevel != 0)` when deciding whether WAL tar compression is gzip.
The bug is that "compression on" was inferred from level > 0, but --gzip without --compress gives Z_DEFAULT_COMPRESSION (-1), so WAL was streamed uncompressed.
Re-expressed as `algorithm == GZIP && level > 0`, so -1 (default level) falls back to PG_COMPRESSION_NONE for pg_wal.tar.

Failing oracle case:
- src/bin/pg_basebackup|t/010_pg_basebackup.pl|two files created with --gzip (base.tar.gz and pg_wal.tar.gz)
