repro.sh: creates a WAL-mode dest.db and a rollback-mode src.db, runs `.backup dest.db` from src.db, then prints dest.db's journal_mode.
Clean: `wal` (backup leaves the destination in WAL mode). Buggy: `delete` (the WAL version bytes are not set, so the destination reverts to rollback mode).
