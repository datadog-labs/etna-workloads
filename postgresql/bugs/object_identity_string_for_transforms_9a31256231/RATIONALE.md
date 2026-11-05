# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9a312562314abcec91ae9cff3a4af37196c3886e ("Fix object identity string for transforms"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/objectaddress.c

Failing oracle cases:
- `src/test/regress||object_address`
