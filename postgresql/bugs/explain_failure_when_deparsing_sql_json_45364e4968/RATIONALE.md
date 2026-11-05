# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 45364e49688a2a845c6b43b182da3b5f3d10cff8 ("Fix EXPLAIN failure when deparsing SQL/JSON aggregates"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||sqljson`
