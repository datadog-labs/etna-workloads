# Rationale

Fix: jsonb_group_array()/jsonb_group_object() returned text "[]"/"{}" instead of JSONB when no rows were aggregated.

Changes (src/json.c):
- jsonArrayCompute: removed the `else if( flags & JSON_BLOB )` branch that returned the blob 0x0b for an empty aggregate (pStr==NULL). Reverses the fix's added branch; empty case falls to text "[]".
- jsonObjectCompute: removed the equivalent branch returning 0x0c; falls to text "{}".
(The `flags` hoisting is harmless and left as is; it is still used in the non-empty path.)

Oracle failures: json103-102 (got '[]' text instead of X'0B') and json103-202 (got '{}' instead of X'0C').
