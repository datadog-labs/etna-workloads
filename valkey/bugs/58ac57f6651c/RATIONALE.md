# Rationale

Fix (antirez merge of #4470): string-to-double conversion stopped parsing at an embedded `\0`, so "1\0..." was accepted. The fix compares the end pointer against the string length rather than relying on a NUL terminator.

Changes (tree/src/util.c):
- `string2ld`: dropped the `(size_t)(eptr - buf) != slen` check, leaving only `eptr[0] != '\0'` (the pre-fix check). Used by INCRBYFLOAT/HINCRBYFLOAT.
- `string2d`: replaced `(size_t)(eptr - s) != slen` with `eptr[0] != '\0'`. Same defect for the double path (`getDoubleFromObject`).

Oracle failure: `string to double with null terminator` in tests/unit/type/incr.tcl. INCRBYFLOAT on a value containing an embedded NUL succeeds (returns 2) instead of `ERR ... valid`. The other 31 cases pass.
