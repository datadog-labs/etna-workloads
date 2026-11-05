# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e0e492e5a928e9c9eda01eeebadcfc36f9f8e7b7 ("Track nesting depth correctly when drilling down into RECORD Vars."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_target.c, src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||rowtypes`
