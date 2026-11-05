# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cd5afd8175e256fa401cf440d06304df746abe62 ("Add collation assignment to CALL statement"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/analyze.c

Failing oracle cases:
- `src/test/regress||create_procedure`
