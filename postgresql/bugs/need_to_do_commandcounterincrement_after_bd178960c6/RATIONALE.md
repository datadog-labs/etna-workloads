# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bd178960c69bae972c274af8102da9018df8196a ("Need to do CommandCounterIncrement after StoreAttrMissingVal."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||inherit`
