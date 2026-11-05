# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 66ec24276b18d111b916e6189b25e5c0a998a1f2 ("pg_unicode_fast: fix final sigma logic."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/common/unicode_case.c

Failing oracle cases:
- `src/test/regress||collate.utf8`
