# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d91353f4b21f10417d142e6ac17a0490adae867c ("Fix handling of NaN values in BRIN minmax multi"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/brin/brin_minmax_multi.c

Failing oracle cases:
- `src/test/regress||brin_multi`
