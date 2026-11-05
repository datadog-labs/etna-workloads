# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 089aac631b5ba53be0ecf8ea2e8d81388d69629c ("Fix validation of COPY FORCE_NOT_NULL/FORCE_NULL for the all-column cases"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/copy.c

Failing oracle cases:
- `src/test/regress||copy2`
