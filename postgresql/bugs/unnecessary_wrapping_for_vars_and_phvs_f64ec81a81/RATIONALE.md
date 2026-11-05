# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f64ec81a810ebd4649beb6c153844fa9ae1ecffe ("Avoid unnecessary wrapping for Vars and PHVs"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/prep/prepjointree.c

Failing oracle cases:
- `src/test/regress||subselect`
