# Rationale

File: src/backend/commands/dbcommands.c, function dbase_redo (hunks in fix_impl.patch for dbase_redo).

- XLOG_DBASE_CREATE_FILE_COPY: removed creation of the missing parent directory of the target
  (recovery_create_dbdir(parent_path, true)) and of the missing source directory
  (recovery_create_dbdir(src_path, false)).
- XLOG_DBASE_CREATE_WAL_LOG: removed the recovery_create_dbdir(parent_path, true) call before
  CreateDirAndVersionFile.

Without these, replay of CREATE DATABASE records fails on a standby when the tablespace directory
was already dropped later in the WAL stream (the original bug). recovery_create_dbdir is left defined but unused.

Traces to fix.patch hunks in dbcommands.c dbase_redo (both CREATE_FILE_COPY and CREATE_WAL_LOG).

Failing oracle cases (all 3):
- src/test/recovery|t/033_replay_tsp_drops.pl|invalid directory creation is detected
- src/test/recovery|t/033_replay_tsp_drops.pl|standby node started for FILE_COPY
- src/test/recovery|t/033_replay_tsp_drops.pl|standby node started for WAL_LOG
