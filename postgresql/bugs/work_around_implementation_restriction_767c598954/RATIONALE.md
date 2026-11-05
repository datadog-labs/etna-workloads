# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 767c598954bbf72e0535f667e2e0667765604b2a ("Work around implementation restriction in adjust_appendrel_attrs."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/allpaths.c

Failing oracle cases:
- `src/test/regress||join`
