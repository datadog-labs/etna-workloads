# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0a5f06b84de76939cf9805e4266d47c2e8bf66df ("Fix a few issues with REINDEX grammar"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/gram.y

Failing oracle cases:
- `src/bin/scripts|t/090_reindexdb.pl|OID change after REINDEX DATABASE CONCURRENTLY`
- `src/test/regress||create_index`
