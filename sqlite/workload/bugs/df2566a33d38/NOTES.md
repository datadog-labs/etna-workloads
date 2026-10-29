repro.sh: attaches a second DB, sets both to journal_mode=persist, and commits a
multi-file transaction (which writes a master journal). It then prints the size
of test.db-journal.

Clean: `journal size: 0` (journal truncated after a multi-file commit).
Buggy: `journal size: 9287` (the journal is only header-zeroed, not truncated).
This corresponds to jrnlmode-2.2 and 2.4.
