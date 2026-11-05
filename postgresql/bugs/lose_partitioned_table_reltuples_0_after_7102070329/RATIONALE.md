# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7102070329d8147246d2791321f9915c3b5abf31 ("Don't lose partitioned table reltuples=0 after relhassubclass=f."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/analyze.c

Failing oracle cases:
- `src/test/regress||vacuum`
