# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 558c9d75fe3b38508296840e606737c664fc3b70 ("Fix PHJ match bit initialization."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeHash.c

Failing oracle cases:
- `src/test/regress||join_hash`
