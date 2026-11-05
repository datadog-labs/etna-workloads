# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 149c875fc20b2025608a2b3e4a0eb2821a879894 ("Fix attnum remapping in generateClonedExtStatsStmt()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_utilcmd.c

Failing oracle cases:
- `src/test/regress||create_table_like`
