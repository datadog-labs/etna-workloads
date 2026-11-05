# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 492a69e1407029f8c673484f44aa719a63323d77 ("Reject ADD CONSTRAINT NOT NULL if name mismatches existing constraint"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c, src/backend/catalog/pg_constraint.c, src/include/catalog/pg_constraint.h

Failing oracle cases:
- `src/test/regress||constraints`
