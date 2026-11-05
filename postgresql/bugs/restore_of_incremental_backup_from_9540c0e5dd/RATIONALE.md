# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9540c0e5dd40df47cbea9a596975e6688ccd70a3 ("Prevent restore of incremental backup from bloating VM fork."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/heap/visibilitymap.c, src/backend/postmaster/walsummarizer.c, src/include/access/visibilitymap.h

Failing oracle cases:
- `src/bin/pg_combinebackup|t/011_ib_truncation.pl|WAL summary has correct VM fork truncation limit`
