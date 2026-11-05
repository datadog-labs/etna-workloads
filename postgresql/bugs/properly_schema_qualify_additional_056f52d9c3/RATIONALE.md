# Rationale

File: src/backend/catalog/objectaddress.c, function getObjectDescription().

Hunks (all trace to the matching hunks of fix_impl.patch): OCLASS_COLLATION, OCLASS_CONVERSION,
OCLASS_STATISTIC_EXT, OCLASS_TSPARSER, OCLASS_TSDICT, OCLASS_TSTEMPLATE, OCLASS_TSCONFIG.
In each, the "Qualify the name if not visible in search path" check (XxxIsVisible ->
get_namespace_name) was replaced by `nspname = NULL;`. The name is then passed to
quote_qualified_identifier() with no schema, so descriptions of these objects are never
schema-qualified, even when the object is not visible in the search path. That is the original bug.

Failing oracle case: src/test/regress||alter_table
