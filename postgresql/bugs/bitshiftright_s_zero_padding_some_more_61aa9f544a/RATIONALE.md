# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 61aa9f544a91f2908e4c7cd549907cdc5b6f1c82 ("Fix bitshiftright()'s zero-padding some more."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/varbit.c

Failing oracle cases:
- `src/test/regress||bit`
