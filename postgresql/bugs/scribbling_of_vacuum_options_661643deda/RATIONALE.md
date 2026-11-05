# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 661643dedad97f8b924991fdc739b1f47b0fb60b ("Avoid scribbling of VACUUM options"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/vacuum.c

Failing oracle cases:
- `src/test/modules/injection_points||vacuum`
