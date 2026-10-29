# Rationale

Changed `src/printf.c` (%j/%J escape loop): `ch<=0x1f` -> `ch<0x1f`.

This reverses the fix hunk that changed `<0x1f` to `<=0x1f`. Control character 0x1f is
no longer escaped, so it is emitted raw instead of as `\u001f`.

The other fix hunks (the `i==px` guard, `j<i-1` -> `j<i`, and the width/errcode
checks) were not reverted.

Oracle failure: `printf-20.24` (`format('<%j>','abc'||char(0x1f)||'def')`).
Expected `<abc\u001fdef>`, got `<abc<0x1f>def>`, i.e. the raw control byte (shown as `<abcdef>`).
