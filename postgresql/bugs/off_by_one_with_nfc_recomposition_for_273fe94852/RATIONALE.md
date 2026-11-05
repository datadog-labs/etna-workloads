# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 273fe94852b3a7e34fd171e8abdf1481beb302fa ("Fix off-by-one with NFC recomposition for Hangul U+11A7 (TBASE)"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/common/unicode_norm.c

Failing oracle cases:
- `src/test/regress||unicode`
