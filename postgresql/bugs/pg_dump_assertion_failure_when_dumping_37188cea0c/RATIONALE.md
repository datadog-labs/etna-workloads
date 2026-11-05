# Rationale

## Change
File `src/src/bin/pg_dump/pg_dump.c`, function `dumpCollation`.

Traces to the second fix_impl.patch hunk (the `@@ -13446,35 +13458,60 @@` hunk). The fix replaced the
old `if (colllocale != NULL) ... else { Assert(collcollate != NULL); Assert(collctype != NULL); ... }`
logic with a per-provider branch. The per-provider branch handles the `'d'` (default) provider, which has no locale
fields, and emits no locale for it. I restored the old logic: the provider-specific branches are gone, and the
code asserts that collcollate and collctype are non-NULL whenever colllocale is NULL.

Dumping pg_catalog includes the default collation, where all of these fields are NULL.
The asserts now fire, so pg_dump aborts with an assertion failure.

I did not touch the first hunk (the pre-v15 empty-string-to-NULL handling), because it does not affect the failure here.

## Failing oracle cases
10040 of 13808 cases fail, spread across the pg_dump runs in `src/bin/pg_dump|t/002_pg_dump.pl`. Examples:
`test_schema_plus_large_objects: should not dump ...` and the other pg_dump cases whose dump run aborts.
Logs are in logs/oracle.log.
