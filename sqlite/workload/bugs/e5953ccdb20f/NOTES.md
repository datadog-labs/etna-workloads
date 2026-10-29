# Reproducer (repro.sh)

Opens a file database, enters `locking_mode=EXCLUSIVE`, creates a table, cycles
journal_mode PERSIST -> DELETE, returns to `locking_mode=NORMAL`, then switches
PERSIST -> DELETE again. This is the jrnlmode-8.x sequence, reduced.

- clean: prints the pragma results, exit 0.
- buggy: aborts with `assert_pager_state: Assertion
  'pPager->changeCountDone==0 || pPager->eLock>=RESERVED_LOCK' failed`
  (exit 134). The injection removes the `changeCountDone` reset on unlock, and
  restores the old journal-deletion path that skips the unlock handling.
