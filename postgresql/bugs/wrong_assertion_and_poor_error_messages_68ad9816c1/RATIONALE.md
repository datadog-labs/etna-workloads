# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 68ad9816c189958a0731d8d5ead7545878fdf15d ("Fix wrong assertion and poor error messages in "COPY (query) TO"."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/copyto.c

Failing oracle cases:
- `src/test/regress||copydml`
