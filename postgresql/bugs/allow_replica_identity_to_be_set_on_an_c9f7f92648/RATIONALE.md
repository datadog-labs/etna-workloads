# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c9f7f926484d69e2806e35343af7e472fadfede7 ("Allow REPLICA IDENTITY to be set on an index that's not (yet) valid."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/index.c, src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||replica_identity`
