# Rationale

File: src/pl/plpython/plpy_typeio.c, function PLySequence_ToArray_recurse (called from PLySequence_ToArray).

Traces to the fix.patch hunks in PLySequence_ToArray that dropped the hand-rolled size computation
(`len *= dims[ndim]`, where a zero-length sublist made len 0). The code has since been rewritten
to use an ArrayBuildState, so the original lines no longer exist. The equivalent today is the
handling of a zero-length sublist when a dimension is added. The change adds a dimension only when
the sublist length is > 0. A zero-length sublist is therefore silently ignored in the dimension info.

Effect: `[[], 1]` is no longer rejected. The empty sublist is dropped and the following scalar is
accepted, so the dimension bookkeeping disagrees with the real element layout. This is the same
class of bug as the original, where a zero-length sublist was mishandled when sizing the array.

Failing oracle case: src/pl/plpython||plpython_types
