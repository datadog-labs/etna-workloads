# Rationale

## Change: tree/src/json.c, jsonMergePatch(), "no match" branch

Fix hunk reversed: `if( j>=pTarget->n )` -> `if( j>=pTarget->n && pPatch[i+1].eType!=JSON_NULL )`
(the "don't append a key whose patch value is NULL" check).

In 3.54.1 the equivalent test is the `else if( x>0 )` guarding Algorithm
line 13 (x is the patch value's JSONB type; 0 is JSONB_NULL). Changing it to a
plain `else` restores the pre-fix behaviour: a patch label absent from the
target with a NULL value is appended to the target as `"key":null` instead of
being ignored (RFC 7396 says nulls remove, never add).

The other fix hunks (array-target loop bounds, iRoot/iAppend offsets, label
compare, OOM handling) belong to the old JsonNode representation and have no
counterpart in the JSONB implementation; only the null check maps over.

## Oracle failures
json104-200, 210, 220, 306, 313, 314: e.g. `json_merge_patch('[1,2,3]','{"x":null}')`
returns `{"x":null}` instead of `{}`; `{"a":"b"}` patched with `{"c":null}`
yields `{"a":"b","c":null}`.
