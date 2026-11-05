# Rationale

Changed: src/backend/commands/extension.c, ExecAlterExtensionContentsStmt().
Traces to the extension.c hunks of fix_impl.patch: removed the call to
recordExtObjInitPriv() in the ADD branch and removeExtObjInitPriv() in the DROP branch.
Without them, ALTER EXTENSION ... ADD/DROP no longer records/removes pg_init_privs
entries, so pg_dump (incl. binary_upgrade) mis-handles ACLs of objects added/dropped
via ALTER EXTENSION. The helper functions remain in aclchk.c (now unused), matching the pre-fix behaviour.

Oracle result: 690/1045 cases fail, all in src/test/modules/test_pg_dump|t/001_base.pl (many reported 'missing', since the test script aborts), e.g. 'without_extension_internal_schema: should not dump GRANT SELECT ON TABLE regress_pg_dump_table', '... should not dump REVOKE SELECT regress_pg_dump_table_added post-ALTER EXTENSION'.
