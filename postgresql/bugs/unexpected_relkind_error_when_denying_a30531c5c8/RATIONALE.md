# Rationale

## src/backend/catalog/objectaddress.c, get_relkind_objtype()
Traces to the fix_impl.patch hunk that added `case RELKIND_TOASTVALUE: return OBJECT_TABLE;` and made `default:` return OBJECT_TABLE instead of `elog(ERROR, "unexpected relkind")`.
I removed the TOASTVALUE case and restored the `elog(ERROR, "unexpected relkind: %d")` default. An ACL failure on a toast table (or any other relkind with no OBJECT_* mapping) then raises "unexpected relkind" instead of a normal permission-denied message.

The comment-only hunks and the alter.c hunks, which only moved when get_object_type() is called, are not needed to bring back the failure. I left them alone to keep the change minimal.

## Failing oracle cases
- src/test/regress||create_index
