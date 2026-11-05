# Rationale

Changes in src/backend/catalog/pg_publication.c (traces to the fix.patch hunks in the same file):

1. `filter_partitions()`: it takes an extra `schemarelids` argument again. A partition is now skipped only if its ancestor is in the list AND the partition or the ancestor is in a schema publication's relations. This reverses the hunk that dropped the `schemarelids` condition.
2. `pg_get_publication_tables()`: it collects the schema-publication relids (`all_schemarelids`) and passes them to `filter_partitions`. This reverses the hunk that made filtering unconditional for `pubviaroot`.

Why it brings the bug back: with `publish_via_partition_root`, a partition and its parent that are both published through plain `FOR TABLE` (not schema) are no longer filtered. `pg_get_publication_tables` then returns both the child and the parent, so the child's data is published twice.

Failing oracle cases: see the oracle run output (filled in below).

44 of 75 oracle cases fail, mostly in src/test/subscription t/013_partition.pl (e.g. tab5 updates, tab3_1/tab2_1 updates, 'updating a row that was modified by a different origin'). Full list in logs/oracle.log.
