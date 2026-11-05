# Rationale

Changed file: src/src/bin/pg_rewind/filemap.c, function process_source_file and process_target_file.

Both hunks trace to the filemap.c hunks of fix_impl.patch. The fix added a block to each function that treats a `pg_xlog` symlink as a directory. In current code the directory is named `pg_wal`.
I removed both "pretend pg_wal is a directory" blocks.
(The fix's third filemap.c hunk, the `pg_xlog` exemption in the FILE_TYPE_DIRECTORY case, no longer exists in current code, so there was nothing to revert.)
Without these blocks, a pg_wal symlink is handled as a symlink entry. pg_rewind then touches the symlink itself, or complains when the source and target differ on whether it is a symlink.

Failing oracle cases (src/bin/pg_rewind t/004_pg_xlog_symlink.pl):
- pg_rewind local
- pg_rewind remote
- recovery conf file sets dbname
- standby.signal created after pg_rewind
- table content: query result matches
- table content: query result matches#2
