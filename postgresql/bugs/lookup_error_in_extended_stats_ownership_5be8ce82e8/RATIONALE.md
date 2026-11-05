# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5be8ce82e84f8f3604916c06668990c524f3856d ("Fix lookup error in extended stats ownership check"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/catalog/objectaddress.c

Failing oracle cases:
- `src/test/regress||stats_ext`
