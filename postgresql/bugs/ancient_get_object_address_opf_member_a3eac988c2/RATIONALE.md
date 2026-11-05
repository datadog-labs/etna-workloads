# Rationale
All hunks are in src/backend/catalog/objectaddress.c, get_object_address_opf_member(), tracing to the fix.patch hunks of the same function:
- `typenames[2]` reverted from `TypeName *` to `char *`.
- Loop: `typenames[i] = strVal(lfirst(cell))` (strVal on a TypeName node, not a String: invalid read) and the TypeName is passed directly to get_object_address_type.
- The two "operator/function %d (%s, %s) ... does not exist" errmsg calls pass typenames[] directly instead of via TypeNameToString().
Result: garbage/crash when the member lookup fails or names are reported.

Failing oracle case: src/test/regress||object_address
