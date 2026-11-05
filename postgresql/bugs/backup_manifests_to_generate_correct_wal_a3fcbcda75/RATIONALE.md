# Rationale

## Changed hunk
File: src/src/backend/backup/backup_manifest.c, function AddWALInfoToBackupManifest (file path in the export: src/backend/backup/backup_manifest.c).

Traces to the single implementation hunk in fix.patch (backup_manifest.c). The fix chose the WAL range start by comparing `starttli == entry->tli` (use backup start LSN on the start timeline, otherwise the timeline's begin LSN). I restored the old logic: use `entry->begin` whenever it is valid, otherwise `startptr` (with the "expected start timeline" error when `starttli != entry->tli`).

Why this brings back the bug: on the start timeline after a promotion, `entry->begin` is valid, so the manifest's WAL-Ranges Start-LSN becomes the timeline's beginning rather than the backup start LSN. The manifest then claims WAL ranges that start before the backup and the ranges are wrong across timelines.

## Failing oracle case
- src/bin/pg_verifybackup|t/007_wal.pl|valid base backup with timeline > 1
