# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit fedfcf66506fa9bf2259a88ae711e7ad7bde0011 ("Don't try to parallelize array_agg() on an anonymous record type."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_agg.c

Failing oracle cases:
- `src/test/regress||aggregates`
