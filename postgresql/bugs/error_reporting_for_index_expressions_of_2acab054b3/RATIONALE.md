Changed: src/backend/catalog/index.c, ConstructTupleDescriptor (all hunks of fix_impl.patch reversed).

- The caller-specified column name assignment (namestrcpy from colnames list) is moved back to after the
  simple/expression branch, and simple columns again copy the parent column name (namecpy no longer exists, so
  namestrcpy(&to->attname, NameStr(from->attname)) is used).
- Consequently, for expression columns, to->attname is still empty when CheckAttributeType() is called,
  so the error for prohibited types (e.g. anonymous record) reports an empty column name instead of the index column name.

Failing oracle case: src/test/regress||create_index
