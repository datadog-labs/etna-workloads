# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1e731ed12aac3f2ed99cf13244f5a1571a6eb6e6 ("Fix incorrect row estimates used for Memoize costing"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinpath.c

Failing oracle cases:
- `src/test/regress||join`
