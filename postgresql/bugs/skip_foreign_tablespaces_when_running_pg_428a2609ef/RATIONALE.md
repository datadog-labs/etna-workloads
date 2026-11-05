# Rationale

Changed: `src/bin/pg_checksums/pg_checksums.c`, `scan_directory()`.

Traces to the single fix.patch hunk in `scan_directory`. The fix added special handling when scanning `pg_tblspc`. It resolves each tablespace link and descends only into `TABLESPACE_VERSION_DIRECTORY`, so foreign-version tablespace directories are skipped. I removed that block, so every directory or symlink entry again goes through plain `scan_directory(path, de->d_name, sizeonly)`. Under `pg_tblspc`, pg_checksums then walks into every `pg_tblspc/<oid>/` subdirectory, including tablespace directories from other server versions. It then tries to checksum files that don't belong to this cluster.

Failing oracle case: `src/bin/pg_checksums|t/002_actions.pl|succeeds with foreign tablespace` (1 of 66).
