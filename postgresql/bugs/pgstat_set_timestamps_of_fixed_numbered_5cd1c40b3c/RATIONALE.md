# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5cd1c40b3ce9600f129fd1fea9850e1affaf31d5 ("pgstat: set timestamps of fixed-numbered stats after a crash."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/activity/pgstat.c

Failing oracle cases:
- `src/test/recovery|t/029_stats_restart.pl|post immediate restart: reset timestamp is new`
