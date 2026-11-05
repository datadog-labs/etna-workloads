# Rationale
File: src/backend/catalog/objectaddress.c, function getObjectDescription(), case UserMappingRelationId.
Traces to the first and second getObjectDescription hunks of fix_impl.patch, reversed. The code no longer reads the
user mapping's umserver or looks up the ForeignServer. The description is back to "user mapping for %s" and no longer
says "on server %s". Two user mappings for the same user on different servers therefore get identical descriptions.
The identity-parts hunk was left alone because the commit is about the object description.

Failing oracle case: src/test/regress||foreign_data
