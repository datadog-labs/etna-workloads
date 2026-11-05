# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3aee6283709f6a7d826b3fb5773cc4496788a5df ("Fix "variable not found in subplan target lists" in semijoin de-duplication."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/pathnode.c

Failing oracle cases:
- `src/test/regress||join`
