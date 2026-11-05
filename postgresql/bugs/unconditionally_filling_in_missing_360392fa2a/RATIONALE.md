# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 360392fa2a9bb74338b4864790d18eadb13fd8a8 ("Avoid unconditionally filling in missing values with NULL in pgoutput."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/pgoutput/pgoutput.c

Failing oracle cases:
- `src/test/subscription|t/100_bugs.pl|check replicated update on subscriber`
