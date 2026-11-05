# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e8583126833a53f4eebe28a8de45d128f01ff664 ("Fix netmask handling in inet_minmax_multi_ops"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/brin/brin_minmax_multi.c

Failing oracle cases:
- `src/test/regress||brin_multi`
