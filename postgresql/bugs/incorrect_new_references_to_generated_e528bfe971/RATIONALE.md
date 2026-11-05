# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e528bfe971900fcd1a74da53931ade4c06eca662 ("Fix incorrect NEW references to generated columns in rule rewriting"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||generated_stored`
- `src/test/regress||generated_virtual`
