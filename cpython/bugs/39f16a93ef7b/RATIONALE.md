# Rationale

## Bug

gh-142555: `array.__setitem__` could crash (NULL pointer dereference or
out-of-bounds write) when the value being stored is converted via a
re-entrant `__index__` (for integer typecodes) or `__float__` (for `f`/`d`)
that mutates the array itself (e.g. `array.clear()` or `array.pop()`),
shrinking it or freeing its buffer *after* the index was already validated
by the caller but *before* the per-type `*_setitem` helper actually wrote
into `ap->ob_item`.

The fix added a `CHECK_ARRAY_BOUNDS` (and `CHECK_ARRAY_BOUNDS_WITH_CLEANUP`
for the cases that may have already done an extra incref on `v` via
`_PyNumber_Index`) macro, and inserted a call to it in every `*_setitem`
helper, placed right after the value has been parsed/converted (which is
where arbitrary Python code, and thus the mutation, can run) and right
before the raw buffer write. The check re-validates that `ap->ob_item` is
still non-NULL and that `i` is still within `Py_SIZE(ap)`, raising
`IndexError` if not.

## Changes made in `tree/Modules/arraymodule.c`

For each of the following setitem helpers, I removed the
`CHECK_ARRAY_BOUNDS(ap, i);` (or `CHECK_ARRAY_BOUNDS_WITH_CLEANUP(...)`) call
that the fix inserted, restoring the pre-fix code that writes to
`ap->ob_item[i]` without re-checking bounds/NULL after the value conversion:

- `b_setitem`, `BB_setitem`, `h_setitem`, `HH_setitem`, `i_setitem`,
  `II_setitem`, `l_setitem`, `LL_setitem`, `q_setitem`, `QQ_setitem`,
  `f_setitem`, `d_setitem`

Each of these removals reverses exactly one hunk of `fix.patch` (the hunk
that inserted the corresponding `CHECK_ARRAY_BOUNDS[...]` call into that
function); the surrounding code is otherwise untouched and still matches
the fixed tree, so after the removal the function is byte-for-byte the
pre-fix version of that helper (module line-number/offset drift from
unrelated changes elsewhere in the file since the fix landed).

I kept the `CHECK_ARRAY_BOUNDS` macro *definition* itself (also added by
`fix.patch`), because three other setitem helpers — `e_setitem`
(half-float), `cf_setitem` (complex float) and `cd_setitem` (complex
double) — already call this macro in the current v3.15.2 tree even though
`fix.patch`'s hunks never touch those three functions. That means a later,
unrelated commit extended the same macro to those three additional
typecodes after this fix landed. Since `e_setitem`/`cf_setitem`/`cd_setitem`
are outside the scope of `fix.patch`, I left their `CHECK_ARRAY_BOUNDS`
calls in place (per step 4 of TASK.md they are not "clearly the same
defect [introduced by] this fix", they're a separate, later hardening of
the same macro), which requires keeping the macro defined so the file still
compiles. I did not restore `CHECK_ARRAY_BOUNDS_WITH_CLEANUP`, since nothing
in the reverted tree references it any more.

I did not touch `Lib/test/test_array.py` or the NEWS entry (test/doc-only
hunks, excluded by TASK.md).

## Oracle result

Running `./check.sh` builds successfully and the array test module fails:
642 of 1098 oracle cases fail, including the three tests the fix added
specifically for this bug:

- `test_setitem_use_after_clear_with_int_data`
- `test_setitem_use_after_shrink_with_int_data`
- `test_setitem_use_after_clear_with_float_data`

The run additionally crashes (segfault) partway through `LongLongTest`,
which is the NULL-pointer-dereference/out-of-bounds-write the original bug
report described: `array.clear()`/`pop()` inside a re-entrant
`__index__`/`__float__` frees or shrinks `ap->ob_item` while the outer
`*_setitem` call still believes the index is valid, so it writes past the
freed/shrunk buffer.
