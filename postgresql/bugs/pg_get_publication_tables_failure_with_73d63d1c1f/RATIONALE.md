# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 73d63d1c1f676f4fcb289cdf9d052881719eb02f ("Fix pg_get_publication_tables() failure with concurrent DROP TABLE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/pg_publication.c

Failing oracle cases:
- `src/test/isolation||pub-concurrent-drop`
