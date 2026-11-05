# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c6cf6d353c2865d82356ac86358622a101fde8ca ("Fix minmax-multi distance for extreme interval values"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/brin/brin_minmax_multi.c

Failing oracle cases:
- `src/test/regress||brin_multi`
