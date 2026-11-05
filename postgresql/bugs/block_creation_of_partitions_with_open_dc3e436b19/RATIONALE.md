# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit dc3e436b191a8f8d6f35fad952dd3dc314ccabf9 ("Block creation of partitions with open references to its parent"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||create_table`
