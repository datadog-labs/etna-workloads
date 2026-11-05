# Rationale
Hunks: src/backend/catalog/objectaddress.c, ObjectProperty[] entries for "publication" and "subscription".
Trace: both hunks of fix_impl.patch (-1 -> ACL_KIND_PUBLICATION / ACL_KIND_SUBSCRIPTION). In current code that field is
the ObjectType (OBJECT_PUBLICATION / OBJECT_SUBSCRIPTION), so I restored `(ObjectType) -1`. With no valid object type,
ALTER PUBLICATION/SUBSCRIPTION RENAME (via the generic rename path, which looks up the object type's property) fails/crashes.

Failing oracle cases: src/test/regress||publication, src/test/regress||subscription
