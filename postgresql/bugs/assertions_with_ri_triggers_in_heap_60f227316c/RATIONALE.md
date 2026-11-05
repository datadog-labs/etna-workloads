# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 60f227316c0ebf5f4f8296f11cedc9360e9cb8ae ("Fix assertions with RI triggers in heap_update and heap_delete."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/heap/heapam.c, src/include/access/tableam.h

Failing oracle cases:
- `src/test/isolation||fk-snapshot`
