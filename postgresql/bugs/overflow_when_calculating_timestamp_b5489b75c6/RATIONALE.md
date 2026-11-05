# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b5489b75c6ce9517ab5f9d6f1d98bc928f6d5bd5 ("Fix overflow when calculating timestamp distance in BRIN"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/access/brin/brin_minmax_multi.c

Failing oracle cases:
- `src/test/regress||brin_multi`
