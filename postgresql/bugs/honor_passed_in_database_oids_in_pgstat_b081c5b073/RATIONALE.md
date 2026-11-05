# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b081c5b07309e5f95fec90eef5041bcc7a25a794 ("Honor passed-in database OIDs in pgstat_database.c"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/activity/pgstat_database.c

Failing oracle cases:
- `src/test/regress||stats`
