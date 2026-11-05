# Rationale
File: src/backend/commands/cluster.c, function swap_relation_files().
Traces to the sole fix_impl.patch cluster.c hunks (three): removed the relam1/relam2 variables, their
assignments from relform1/relform2, and the block calling changeDependencyFor() for AccessMethodRelationId
when relam1 != relam2. Without it, after ALTER TABLE .. SET ACCESS METHOD (which swaps relfiles via
rewrite) pg_depend still points to the old AM.

Failing oracle case: src/test/regress||create_am
