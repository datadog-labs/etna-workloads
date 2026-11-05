# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e16c9cd331314fcf3f7a8d9e3e20aaee448162e4 ("Fix error message for ALTER CONSTRAINT ... NOT VALID"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/gram.y

Failing oracle cases:
- `src/test/regress||constraints`
- `src/test/regress||foreign_key`
