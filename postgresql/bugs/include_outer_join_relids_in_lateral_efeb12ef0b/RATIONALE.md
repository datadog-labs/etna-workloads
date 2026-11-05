# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit efeb12ef0bfef0b5aa966a56bb4dbb1f936bda0c ("Don't include outer join relids in lateral_relids bitmapsets."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/initsplan.c

Failing oracle cases:
- `src/test/regress||join`
