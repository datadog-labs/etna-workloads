# Reintroduced bug: pg_dump ignores GRANT OPTION among initial privileges

All hunks are in `src/src/bin/pg_dump/dumputils.c`. They trace to the single `dumputils.c` diff in fix.patch.

1. `buildACLCommands()`, REVOKE loop over `revokeitems[]`.
   - Traces to fix hunk 1, which removes the separate `REVOKE GRANT OPTION FOR` handling and passes NULL for `privswgo`.
   - `parseAclItem` is called with `privswgo` again.
   - A second `REVOKE GRANT OPTION FOR ... FROM grantee` is emitted for the grant-option privileges.
   - The code was restructured since the fix, so this is adapted to the current layout.
   - Initial (base) privileges that carry grant option get revoked in the wrong form. Plain `REVOKE` is skipped for them, and a separate partial revoke is emitted instead.

2. `parseAclItem()`, `CONVERT_PRIV` macro.
   - Traces to fix hunk 3: the `&& privswgo != NULL` check is removed.
   - Callers that pass NULL (the older revoke handling) would then dereference NULL when a privilege has `*`.
   - In the current code it takes the grant-option split path unconditionally.

The comment-only hunk (fix hunk 2, the `parseAclItem` header comment) is not reverted.

## Failing oracle cases
697 of 1044 oracle cases fail, almost all in `src/test/modules/test_pg_dump|t/001_base.pl`. Examples:
- `without_extension_internal_schema: should not dump REVOKE GRANT OPTION FOR UPDATE ON SEQUENCE wgo_then_regular`
- `without_extension_internal_schema: should not dump REVOKE ALL ON FUNCTION wgo_then_no_access`
- the many `should not dump GRANT ...` cases in the same group
