# Rationale
File: src/backend/utils/adt/jsonfuncs.c, functions jsonb_object_field, jsonb_object_field_text, jsonb_array_element, jsonb_array_element_text.

Traces to the fix.patch hunks in those same functions. The fix replaced the "cannot call X on a scalar/array/object" errors with `if (!JB_ROOT_IS_xxx(jb)) PG_RETURN_NULL();`. I restored the errors, so applying `->` or `->>` to the wrong container type raises an error instead of returning NULL.

Only the jsonb operator hunks were reverted. The json-side rewrite (get_worker and the path functions) was left alone, because the jsonb regression expectations are enough to expose the bug.

Failing oracle case: src/test/regress||jsonb (json still passes).
