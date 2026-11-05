# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 23886581b58c7e5d005d6346c0024a45801cc5a9 ("Fix old corner-case logic error in final_cost_nestloop()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/costsize.c

Failing oracle cases:
- `src/test/regress||join`
