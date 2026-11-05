# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d811ce6ea343fa8a0b6b9cd7e9cddcbdaa27962b ("pgstat: Fix transactional stats dropping for indexes"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c, src/backend/catalog/index.c

Failing oracle cases:
- `src/test/regress||stats`
