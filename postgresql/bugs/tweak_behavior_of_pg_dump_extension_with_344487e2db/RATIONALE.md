# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 344487e2db03f3cec13685a839dbc8a0e2a36750 ("Tweak behavior of pg_dump --extension with configuration tables"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/bin/pg_dump/pg_dump.c

Failing oracle cases:
- `src/test/modules/test_pg_dump|t/001_base.pl|without_extension: should not dump COPY public.regress_table_dumpable (col1)`
- `src/test/modules/test_pg_dump|t/001_base.pl|without_extension: should not dump SETVAL SEQUENCE regress_seq_dumpable`
- `src/test/modules/test_pg_dump|t/001_base.pl|without_extension_explicit_schema: should not dump COPY public.regress_table_dumpable (col1)`
- `src/test/modules/test_pg_dump|t/001_base.pl|without_extension_explicit_schema: should not dump SETVAL SEQUENCE regress_seq_dumpable`
