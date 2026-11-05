# Rationale

## Changed hunks (src/bin/pg_dump/pg_dump.c)

1. `getAdditionalACLs()`: the pg_init_privs query now gets
   `WHERE objoid <> 'public'::regnamespace` when `dopt->outputClean` (-c) is set.
   A local `dopt = fout->dopt` was added for this.
   - Traces to the fix.patch hunk in `getNamespaces()`, which replaced
     `pip.objoid <> 'public'::regnamespace` with a coalesce() lookup of the public schema's OID.
   - In REL_18_6, `getNamespaces()` no longer joins pg_init_privs. The public
     schema's initprivs are ignored in C instead. The equivalent place for the
     query-level exclusion is now the pg_init_privs read in `getAdditionalACLs()`.
   - The `'public'::regnamespace` cast raises an error when the public schema is
     missing, so `pg_dump -c` fails on a database with no public schema. That is the original bug.
   - This is an adaptation, not a literal reversal. The exclusion did not exist in this form in the current code.

## Failing oracle cases
The `pg_dump -c` run against a database without public (`defaults_no_public_clean`) now errors out.
Many 002_pg_dump.pl cases fail as a result. 10309 of 13808 fail in the oracle run,
for example `test_schema_plus_large_objects: should not dump ...` and other cases in t/002_pg_dump.pl.
The full list is in logs/oracle.log.
