# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f0d0394e84ceeda6f22eb3fdb89bd8adbfc13985 ("Fix parsing of ISO-8601 interval fields with exponential notation."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/datetime.c

Failing oracle cases:
- `src/test/regress||interval`
