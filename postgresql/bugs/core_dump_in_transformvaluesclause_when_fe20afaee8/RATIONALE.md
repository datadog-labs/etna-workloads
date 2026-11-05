# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fe20afaee8aac7838ed6e4a76baa83e547629582 ("Fix core dump in transformValuesClause when there are no columns."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/analyze.c

Failing oracle cases:
- `src/test/regress||select`
