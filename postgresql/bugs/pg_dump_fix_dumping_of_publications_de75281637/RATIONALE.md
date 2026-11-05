Changed: src/bin/pg_dump/pg_dump.c, getPublicationTables (the per-table publication-rel loop; in current code it lives in getPublicationTables' publication rel setup, ~line 4785).
Traces to the sole fix_impl.patch hunk: removed `pubrinfo[j].dobj.name = tbinfo->dobj.name;`.
Why: the DO_PUBLICATION_REL object is left with a NULL name, so name-based handling (sorting, dump-object naming, pg_dump's tests) breaks/crashes when publications with tables exist.

Failing oracle cases: 13772/13808, essentially all of src/bin/pg_dump t/002_pg_dump.pl (all runs, e.g. test_schema_plus_large_objects: should not dump ... ['missing']).
