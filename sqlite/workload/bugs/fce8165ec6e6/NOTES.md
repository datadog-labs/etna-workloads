repro.sh replays exclusive-7.1 on a file database: locking_mode=EXCLUSIVE, journal_mode=WAL,
locking_mode=NORMAL, user_version, journal_mode=DELETE.

Clean shell: prints exclusive/wal/normal/0/delete and exits 0.
Buggy shell: aborts at the last pragma with the assertion
`pPager->changeCountDone==0 || pPager->eLock>=RESERVED_LOCK` in assert_pager_state (exit 134).
