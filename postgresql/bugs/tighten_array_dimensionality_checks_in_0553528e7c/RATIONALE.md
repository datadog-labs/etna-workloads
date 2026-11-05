# Rationale

## src/pl/plpython/plpy_typeio.c, PLySequence_ToArray_recurse()
Traces to the fix.patch hunk that introduces the new recursive checker (the "scalar after some sub-arrays at same level?" check, `*ndims != cur_depth`, in the scalar branch).
Removing it brings back the bug: a scalar element sitting at a different nesting depth than sibling sub-lists (e.g. `[['a'], 'b']`) is no longer rejected. Ragged or mixed-depth lists are accepted instead of raising "multidimensional arrays must have array expressions with matching dimensions".

## Failing oracle cases
- src/pl/plpython||plpython_types
