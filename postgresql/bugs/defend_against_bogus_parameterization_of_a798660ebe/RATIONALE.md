# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a798660ebe3ff1feb310db13b957c5cda4c8c50d ("Defend against bogus parameterization of join input paths."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinpath.c

Failing oracle cases:
- `src/test/regress||join`
