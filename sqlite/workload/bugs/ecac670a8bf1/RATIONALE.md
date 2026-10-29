# Rationale

Fix hunk (src/btree.c, lockBtree): the pre-fix code compared the raw header
page count (`nPageHeader`) with the file size; the fix compares `nPage`, which
is replaced by the file size when the header's two change-counter fields differ
(ticket 89b8c9ac54).

In 3.54.1 the check is `if( nPage>nPageFile )` (with a writable-schema escape).
Changes in tree/src/btree.c, lockBtree:
- Re-added `u32 nPageHeader`, set alongside `nPage` from header offset 28
  (before the change-counter test overwrites `nPage`).
- The check now uses `nPageHeader>nPageFile` instead of `nPage>nPageFile`,
  so a stale header size with mismatched change counters is reported as
  SQLITE_CORRUPT again.

Oracle: filefmt-3.3 fails with "database disk image is malformed" (the
ticket's symptom). Other 41 cases pass.
