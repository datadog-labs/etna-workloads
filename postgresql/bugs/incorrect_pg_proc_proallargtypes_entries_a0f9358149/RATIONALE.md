# Rationale
File: src/include/catalog/pg_proc.dat (the former pg_proc.h DATA lines; catversion hunk skipped, it is just a version bump).

- pg_sequence_parameters: proallargtypes first entry changed from oid to int4 (fix.patch hunk for OID 3078). The input arg sequence_oid is declared `oid` in proargtypes, so proallargtypes disagrees with it.
- pg_identify_object: proallargtypes second entry changed from oid to int4 (fix.patch hunk for OID 3839). The objid arg is declared `oid` in proargtypes.

Both bring back the incorrect proallargtypes entries; opr_sanity checks that proallargtypes input entries match proargtypes.

Failing oracle case: src/test/regress||opr_sanity
