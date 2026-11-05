# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3e91dba8b079c02dc5204108c7e797b402c75779 ("Fix various issues with ALTER TEXT SEARCH CONFIGURATION"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tsearchcmds.c

Failing oracle cases:
- `src/test/regress||tsdicts`
