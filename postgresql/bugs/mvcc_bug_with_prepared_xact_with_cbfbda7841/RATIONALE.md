# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cbfbda78413a5b2f4807e029407dcc98a0e63162 ("Fix MVCC bug with prepared xact with subxacts on standby"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/twophase.c, src/backend/access/transam/xlog.c, src/backend/storage/ipc/procarray.c, src/backend/storage/ipc/standby.c, src/include/storage/standby.h

Failing oracle cases:
- `src/test/recovery|t/009_twophase.pl|Committed prepared transaction is visible to new snapshot in standby`
