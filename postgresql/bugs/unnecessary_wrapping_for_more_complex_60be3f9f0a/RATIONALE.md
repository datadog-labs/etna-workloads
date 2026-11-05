# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 60be3f9f0a64a071822c0711f69c7b5f6467d84f ("Avoid unnecessary wrapping for more complex expressions"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/prep/prepjointree.c

Failing oracle cases:
- `src/test/regress||subselect`
