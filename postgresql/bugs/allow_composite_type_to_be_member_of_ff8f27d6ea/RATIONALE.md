# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ff8f27d6eae2d9ed6dcfa290ebc133fec093f414 ("Don't allow composite type to be member of itself via multirange"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c

Failing oracle cases:
- `src/test/regress||multirangetypes`
