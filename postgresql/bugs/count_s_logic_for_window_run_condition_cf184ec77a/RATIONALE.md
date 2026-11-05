# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cf184ec77a04bf164692a0c7bcd148f1e96b71f2 ("Fix COUNT's logic for window run condition support"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/int8.c

Failing oracle cases:
- `src/test/regress||window`
