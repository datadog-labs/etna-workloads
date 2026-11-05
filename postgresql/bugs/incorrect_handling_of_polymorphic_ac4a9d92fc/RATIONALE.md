# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ac4a9d92fcb6869e757cc729dca2ca5ccf94b185 ("Fix incorrect handling of polymorphic aggregates used as window functions."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/nodeWindowAgg.c

Failing oracle cases:
- `src/test/regress||polymorphism`
