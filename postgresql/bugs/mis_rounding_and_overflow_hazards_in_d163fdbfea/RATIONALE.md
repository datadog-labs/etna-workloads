# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d163fdbfea82a5a578de5bc6392ae84c590bb454 ("Fix mis-rounding and overflow hazards in date_bin()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/timestamp.c

Failing oracle cases:
- `src/test/regress||timestamp`
- `src/test/regress||timestamptz`
