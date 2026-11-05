# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1c7c317cd9d1e5647454deed11b55dae764c83bf ("Clarify use of temporary tables within partition trees"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||alter_table`
- `src/test/regress||create_table`
