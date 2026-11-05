# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b181062aa5727a013c96b64476f884c992b5068d ("Fix incorrect return value for pg_size_pretty(bigint)"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/dbsize.c

Failing oracle cases:
- `src/test/regress||dbsize`
