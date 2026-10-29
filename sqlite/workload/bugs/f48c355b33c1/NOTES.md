Reproducer (repro.sh): builds an incremental-autovacuum db with large freed blobs, runs
incremental_vacuum(248) then (1), reopens, and runs PRAGMA integrity_check.
Clean: prints "ok". Buggy: allocateBtreePage doesn't mark the previous freelist trunk page
writable, so the freelist is corrupted ("Freelist: invalid page number 257", "never used" pages).
Output is truncated with head -3 to keep it small.
