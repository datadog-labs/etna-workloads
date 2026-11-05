# Rationale
File: src/backend/catalog/objectaddress.c, function getObjectIdentityParts (the ConversionRelationId case; fix.patch has the single hunk here).

The fix made the conversion identity schema-qualified with quote_qualified_identifier(), and made objname hold both the schema and the name. I reverted both: the identity uses the unqualified quote_identifier(conname), and objname is list_make1(conname). I also restored the pfree(schema) that the original code had.

Effect: pg_identify_object, pg_describe_object and the related functions return an unqualified conversion name. The object_address regression test expects a schema-qualified name, so it fails.

Failing oracle case: src/test/regress||object_address
