# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 55c3a04d60ccea9e999088fb847ceeb9fd4dd927 ("Fix assorted breakage in to_char()'s OF format option."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/formatting.c

Failing oracle cases:
- `src/test/regress||timestamptz`
