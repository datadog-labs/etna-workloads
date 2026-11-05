# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3f074845a8c190b365e68e39e39017ff70330f2a ("Fix pfree-of-already-freed-tuple when rescanning a GiST index-only scan."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/gist/gistget.c, src/backend/access/gist/gistscan.c

Failing oracle cases:
- `src/test/regress||gist`
