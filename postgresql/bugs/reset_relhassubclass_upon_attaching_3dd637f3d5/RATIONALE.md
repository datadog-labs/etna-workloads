# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3dd637f3d5997eb5ef3ccf8787e6fa091d93cd0c ("Reset relhassubclass upon attaching table as a partition"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c

Failing oracle cases:
- `src/test/regress||alter_table`
