# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit eb145fdfea91ee5dc6d7aad0309527f810f7c90a ("Fix dumping of outer joins with empty qual lists."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||create_view`
