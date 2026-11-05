# Rationale

File: src/backend/utils/adt/jsonfuncs.c, function populate_recordset_object_start.

Traces to the fix.patch hunk at `populate_recordset_object_start`, which added the "Nested objects ... require no special processing" early return for lex_level > 1. I removed that early return. A nested object (level > 1) now creates a fresh hash table and overwrites `_state->json_hash`. This leaks the outer object's hash and loses the fields already collected. Later fields of the outer object go into the nested object's hash. `populate_recordset_object_end` returns early for nested objects, so the outer record is built from the wrong hash.

Oracle case expected to fail: src/test/regress||json
