# Rationale

Changed: src/src/backend/commands/subscriptioncmds.c, `fetch_table_list()`.

Traces to the subscriptioncmds.c hunk of fix.patch, which made the subscriber pass all
publication names to `pg_get_publication_tables(VARIADIC array_agg(pubname))` so the publisher
can filter out partitions whose ancestor is published in another publication of the same
array. The code now calls `pg_get_publication_tables(pubname::text)` once per publication, so
that cross-publication filtering never happens. With publish_via_partition_root, a partition
and its root can both be returned, and the data is synced twice. The original fix's
pg_publication.c changes are already in place in REL_18_6 and are left alone.

Failing oracle cases: 13/137 fail, all in src/test/subscription/t/031_column_list.pl, including
"publication containing both parent and child relation" (and #2),
"publication via partition root applies column list",
"replication with multiple publications with the same column list",
"two publications, publishing the same relation" (and #2).
