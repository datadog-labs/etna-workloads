# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit dd2364ced98553e0217bfe8f621cd4b0970db74a ("Fix bogus logic for reporting which hash partition conflicts."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/partitioning/partbounds.c

Failing oracle cases:
- `src/test/regress||create_table`
