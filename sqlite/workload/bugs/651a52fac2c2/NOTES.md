Reproducer (`repro.sh`): creates a file DB, sets `journal_mode=off` (needs the shell's
`-unsafe-testing` flag), then runs an INSERT...SELECT in a transaction and a savepoint
insert (savepoint-13.2/13.3 of test/savepoint.test).

Clean shell: prints the rows, exit 0. Buggy shell: subjournalPage() no longer skips
work when journal_mode=off, so it aborts with an assertion failure
(`isOpen(pPager->jfd) || pagerUseWal(pPager)`), exit 134.
