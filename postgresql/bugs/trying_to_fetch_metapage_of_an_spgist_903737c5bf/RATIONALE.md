# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 903737c5bf9431c2f983c87ac211082418341805 ("Avoid trying to fetch metapage of an SPGist partitioned index."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/access/spgist/spgutils.c

Failing oracle cases:
- `src/test/regress||indexing`
