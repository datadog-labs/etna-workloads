# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4bc772e2afa55f26734ff3fbdf27601db030b7e5 ("Ignore partitioned tables when processing ON COMMIT DELETE ROWS"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c

Failing oracle cases:
- `src/test/regress||temp`
