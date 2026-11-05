# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ef6168bafe9be1a5781b2c471ffa4650f31f9a77 ("Disable parallel plans for RIGHT_SEMI joins"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinpath.c

Failing oracle cases:
- `src/test/regress||join`
