Creates a database with auto_vacuum=FULL, then runs `PRAGMA auto_vacuum=2; VACUUM;`.
Clean shell reports 2 (incremental) after the VACUUM and when reopened; buggy shell reports 1 because
the incremental flag is no longer preserved across VACUUM (ticket #3663).
