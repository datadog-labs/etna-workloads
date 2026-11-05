# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4fc6a555606de003690d46e900339e78214ee363 ("SQL/JSON: Respect OMIT QUOTES when RETURNING domains over jsonb"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/jsonfuncs.c

Failing oracle cases:
- `src/test/regress||sqljson_queryfuncs`
