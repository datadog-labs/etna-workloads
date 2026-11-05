# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d23ac62afa646b7073a7f0db0a137308459a263b ("Avoid creating a RESULT RTE that's marked LATERAL."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/prep/prepjointree.c

Failing oracle cases:
- `src/test/regress||join`
