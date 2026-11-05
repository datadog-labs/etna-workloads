# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3e3a80f62c09709de899cc7649f1c86c63b78981 ("Fix bug in following update chain when locking a heap tuple"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/heap/heapam.c

Failing oracle cases:
- `src/test/modules/injection_points||heap_lock_update`
