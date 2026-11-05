# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 029dea882a7aa34f46732473eed7c917505e6481 ("Fix ts_headline() edge cases for empty query and empty search text."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/tsearch/wparser_def.c

Failing oracle cases:
- `src/test/regress||tsearch`
