# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f581fa729d8e108fef853c3156267b1f753d0210 ("Fix VM clear WAL logging by registering VM blocks"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/heap/heapam.c, src/backend/access/heap/heapam_xlog.c, src/backend/access/heap/visibilitymap.c, src/include/access/heapam_xlog.h, src/include/access/visibilitymap.h

Failing oracle cases:
- `src/bin/pg_walsummary|t/002_blocks.pl|UPDATE modified 3 blocks`
- `src/bin/pg_walsummary|t/002_blocks.pl|stdout shows VM block 0 modified`
