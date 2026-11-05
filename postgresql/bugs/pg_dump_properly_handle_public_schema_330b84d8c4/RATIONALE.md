# Rationale

fix.patch made pg_dump ignore the pg_init_privs entry for schema `public` when running with `--clean`. The reason is that the schema is dropped and recreated, so its ACL must be dumped in full. The code has since changed. getNamespaces() now always replaces public's initprivs with a synthesized default ACL (`{owner=UC/owner,=U/owner}`). getAdditionalACLs() skips public's pg_init_privs row. The SQL-join hunk no longer exists, so I reversed the same logic in the current code.

## Hunks (both in src/bin/pg_dump/pg_dump.c, traced to the single getNamespaces() hunk of fix_impl.patch)
1. `getNamespaces()`: the public-schema special case is now guarded with `!fout->dopt->outputClean`. In `--clean` mode the synthesized initprivs are no longer set, so public is treated like an ordinary pg_init_privs object again.
2. `getAdditionalACLs()`: the skip of public's pg_init_privs row is also guarded with `!fout->dopt->outputClean`. In `--clean` mode the initdb-time initprivs for public are therefore used, and only the delta from them is dumped.

Together these bring the bug back. With `--clean`, public is dropped and recreated with an empty ACL. pg_dump emits only the difference from the initdb ACL, so an unchanged public schema is restored with no privileges.

## Failing oracle cases
- `clean: should dump REVOKE ALL ON SCHEMA public`
- `clean_if_exists: should dump REVOKE ALL ON SCHEMA public`
- `defaults_tar_format: pg_dump runs` and `defaults_tar_format: pg_restore runs`. These two are probably the script aborting early. I did not confirm that.
- About 10000 later cases in 002_pg_dump.pl are reported "missing". The script stops after the failures above, so the later cases never run. 10041 of 13808 cases fail in total.
