# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 49f3cb453b9b86b771b0a15393893fb317e35572 ("Fix WITHOUT OVERLAPS' interaction with domains."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execIndexing.c, src/backend/parser/parse_utilcmd.c

Failing oracle cases:
- `src/test/regress||without_overlaps`
