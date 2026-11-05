# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a6492ff8970b06b9e27cc314c7d1aa574fcc7b04 ("Fix an oversight in checking whether a join with LATERAL refs is legal."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinrels.c

Failing oracle cases:
- `src/test/regress||join`
