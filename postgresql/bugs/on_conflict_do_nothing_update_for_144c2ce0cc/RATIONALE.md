# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 144c2ce0cc75ff99c66749b0ca5235d037df7c09 ("Fix ON CONFLICT DO NOTHING/UPDATE for temporal indexes"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execIndexing.c, src/backend/optimizer/util/plancat.c

Failing oracle cases:
- `src/test/regress||without_overlaps`
