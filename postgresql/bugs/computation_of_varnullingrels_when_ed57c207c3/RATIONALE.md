# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ed57c207c397a6e6a91e0394cacdc63e0f029173 ("Fix computation of varnullingrels when translating appendrel Var"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/appendinfo.c

Failing oracle cases:
- `src/test/regress||join`
