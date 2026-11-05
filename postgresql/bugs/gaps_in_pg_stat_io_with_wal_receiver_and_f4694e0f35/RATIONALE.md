# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f4694e0f35b218238cbc87bcf8f8f5c6639bb1d4 ("Fix some gaps in pg_stat_io with WAL receiver and WAL summarizer"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/postmaster/walsummarizer.c, src/backend/replication/walreceiver.c, src/backend/utils/activity/pgstat_io.c

Failing oracle cases:
- `src/bin/pg_walsummary|t/002_blocks.pl|UPDATE modified 3 blocks`
- `src/bin/pg_walsummary|t/002_blocks.pl|WAL summary file exists`
- `src/bin/pg_walsummary|t/002_blocks.pl|got exactly one new WAL summary`
- `src/bin/pg_walsummary|t/002_blocks.pl|got new WAL summary after update`
- `src/bin/pg_walsummary|t/002_blocks.pl|stderr is empty`
- `src/bin/pg_walsummary|t/002_blocks.pl|stdout shows VM block 0 modified`
- `src/bin/pg_walsummary|t/002_blocks.pl|stdout shows block 0 modified`
