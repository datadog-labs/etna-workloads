# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1ff39f4ff2b68625cdc37076e5c8281a4eab7f4f ("Fix scale clamping in numeric round() and trunc()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/numeric.c

Failing oracle cases:
- `src/test/regress||numeric`
