# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a99bd8d584ea268d8a3d02d0f0facb74429ffcf9 ("Fix LIKE matching with nondeterministic collations and backslashes."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/like_match.c

Failing oracle cases:
- `src/test/regress||collate.icu.utf8`
