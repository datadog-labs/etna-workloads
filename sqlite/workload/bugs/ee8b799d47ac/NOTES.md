Connection 1 sets journal_mode=persist, writes a row, then holds a read transaction
(SHARED lock) while a persistent, zeroed-header journal is left on disk.
Connection 2 (a second shell process) runs SELECT.

Clean: returns `1|2`. The zeroed journal is seen as not hot.
Buggy: the journal is assumed hot, the EXCLUSIVE lock for rollback fails, and the
shell prints "database is locked (5)" and exits 1.
