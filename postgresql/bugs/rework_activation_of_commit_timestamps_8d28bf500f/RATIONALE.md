# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8d28bf500f6536e295e9c3d7b85cdfec1c4dc913 ("Rework activation of commit timestamps during recovery"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/commit_ts.c, src/backend/access/transam/xlog.c

Failing oracle cases:
- `src/test/modules/commit_ts|t/004_restart.pl|timestamp of disabled tx null after re-enable`
- `src/test/modules/commit_ts|t/004_restart.pl|timestamp of enabled tx null after re-enable`
