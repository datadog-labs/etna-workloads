repro.sh: in an incremental-vacuum WAL database (page_size 4096), one transaction creates 37 tables,
puts a 7000-byte row in t0, deletes it, then drops all tables (test incrvacuum2-5.x).
Clean: COMMIT succeeds, integrity_check "ok", wal_checkpoint `0|40|40`.
Buggy: COMMIT fails with "database disk image is malformed" (btreeDropTable no longer
calls sqlite3PagerWrite on the moved root page), and the shell exits 1.
