# Rationale

Changed: src/backend/backup/basebackup_incremental.c, GetFileBackupMethod().
Traces to the fix_impl.patch hunk in the same function: removes the lookup of the
special BRT entry (relNumber 0) for the db/tablespace pair, which made all files
in a newly created database (XLOG_DBASE_CREATE_FILE_COPY) be backed up fully.
Without it, files in a FILE_COPY-created database lacking per-block WAL records are
treated as unchanged/incremental, so data is missing after combine.

(The walsummarizer.c writer side is left intact; with the reader lookup removed the
special entries are ignored, which restores the buggy behaviour.)

Failing oracle case (confirmed, 1 of 4):
src/bin/pg_combinebackup|t/006_db_file_copy.pl|SELECT * FROM t1: stderr missing table
