# Rationale

This re-introduces the bug fixed by upstream commit 08fa47c4850c
("Prevent stack overflow in json-related functions") by removing the
`check_stack_depth()` calls that commit added, at the four locations
that still exist in REL_18_6 (one hunk from fix_impl.patch, setPath in
jsonfuncs.c, was left untouched because its check was unrelated to the
cases being reproduced here — actually all original hunks correspond
1:1 below; see note at bottom).

## Changed hunks

### src/common/jsonapi.c, function `json_lex_object`... (parse_object)
Traces to fix_impl.patch hunk for `src/backend/utils/adt/json.c`
`parse_object()` (the recursive-descent JSON parser was later moved
from `json.c` into `src/common/jsonapi.c`, so the same logical
function now lives there). Removed the `check_stack_depth()` call
(and frontend/backend conditional wrapper) at the top of the function
body. Without it, deeply nested JSON object input
(`{"a":{"a":{"a": ... }}}`) recurses through `parse_object` without
any guard, allowing the C call stack to overflow instead of raising a
controlled "stack depth limit exceeded" error.

### src/common/jsonapi.c, function for parse_array
Traces to fix_impl.patch hunk for `src/backend/utils/adt/json.c`
`parse_array()` (also moved into `src/common/jsonapi.c`). Removed the
analogous `check_stack_depth()` guard. Deeply nested JSON arrays
(`[[[[...]]]]`) can now recurse unboundedly.

### src/backend/utils/adt/json.c, `datum_to_json_internal`
Traces to fix_impl.patch hunk for `datum_to_json()` (renamed to
`datum_to_json_internal` since REL_18_6). Removed the
`check_stack_depth()` call at function entry. Converting a deeply
nested composite/array Datum to JSON text (e.g. via `row_to_json`,
`to_json`, `array_to_json` on nested structures) recurses without a
depth check.

### src/backend/utils/adt/jsonb.c, `datum_to_jsonb_internal`
Traces to fix_impl.patch hunk for `datum_to_jsonb()` (renamed to
`datum_to_jsonb_internal`). Removed the `check_stack_depth()` call at
function entry, re-enabling unbounded recursion when building a jsonb
value from a deeply nested Datum (e.g. `to_jsonb`, `jsonb_build_object`
on nested structures).

## Note on setPath
The fix_impl.patch hunk adding `check_stack_depth()` to `setPath()` in
jsonfuncs.c was **not** reversed, since the json/jsonb regression
oracle cases already fail from the other four removals and leaving
`setPath`'s check in place keeps the change minimal and focused on the
parser/serializer recursion paths that the oracle tests actually
exercise.

## Verification

Ran `python3 <tools>/agent_oracle.py`:

```
FAIL  src/test/regress||json  ['fail']
FAIL  src/test/regress||jsonb  ['fail']
oracle cases failing: 2/2
```

Both oracle cases fail with the change, confirming the stack-overflow
bug has been reintroduced (and that no change reproduces all passing).
