# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e98a4de7d23a54a6c861795ad8e920a59613e08b ("Use the correct tuplestore read pointer in a NamedTuplestoreScan."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeNamedtuplestorescan.c

Failing oracle cases:
- `src/test/regress||plpgsql`
