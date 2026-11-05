# Reintroduced bug: pg_upgrade copies pg_largeobject_metadata by file

Traces to fix.patch hunks in pg_upgrade/info.c and pg_dump/pg_dump.c (getBlobs).

1. src/bin/pg_upgrade/info.c, get_rel_infos(): the relname list again includes
   'pg_largeobject_metadata' (reverse of the info.c hunk). The table is file-copied
   even though pg_dump now recreates large-object metadata via SQL.
2. src/bin/pg_dump/pg_dump.c, getLOs(): in binary-upgrade mode the dump mask drops
   DUMP_COMPONENT_ACL as well as DATA (reverse of the getBlobs hunk), so LO ACLs are
   not dumped, assuming the metadata is copied by pg_upgrade.

Not reverted: the dumpDatabase relfrozenxid hunk for pg_largeobject_metadata.

Failing oracle cases: 10040 of 13808 fail, nearly all in src/bin/pg_dump t/002_pg_dump.pl (e.g. "test_schema_plus_large_objects: should not dump ..." reported as missing, and binary_upgrade cases). Full list in logs/oracle.log.
