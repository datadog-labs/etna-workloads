# Rationale

File/function: src/backend/utils/adt/acl.c, column_privilege_check().
Traces to the fix.patch hunk in the same function. The fix checks column-level privilege first (via pg_attribute_aclcheck_ext), because that call also detects a missing or dropped column. It then checks table-level privilege.

The bug is restored by reversing the order. The table-level check (pg_class_aclcheck_ext) now runs first and returns 1 when the privilege is held. The column existence check is therefore skipped. A dropped column on a table the role has privileges on now reports true instead of NULL, which is the original has_column_privilege corner case.

The change reuses the existing _ext helpers, so no other hunk is needed.

Failing oracle case: src/test/regress||privileges
