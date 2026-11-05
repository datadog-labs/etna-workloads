# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3b0776fde56763c549df35ce9750f3399bc710b2 ("Compute aggregate argument types correctly in transformAggregateCall()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_agg.c

Failing oracle cases:
- `src/test/regress||jsonb`
