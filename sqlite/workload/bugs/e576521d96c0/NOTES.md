repro.sql replays tkt3918.1-5 (incremental auto-vacuum, freelist set up so the first trunk has one leaf, which is then vacuumed away; then CREATE TABLE t2 allocates a page from the second trunk).
Clean: prints "ok", exit 0. Buggy: "Error near line 11: database disk image is malformed", exit 1.
