# Rationale

## Changed: `src/t_hash.c`, `hincrbyfloatCommand`

The fix added an early `isnan(incr) || isinf(incr)` check (error "value is NaN or Infinity")
before `hashTypeLookupWriteOrCreate`. I removed that check from 9.0.7, which restores the
pre-fix ordering: the key is created before the increment is validated. The later
`isnan(value) || isinf(value)` check ("increment would produce NaN or Infinity") still exists,
so the command fails, but with a different error and after the empty hash has already been created.

## Oracle failure

`HINCRBYFLOAT does not allow NaN or Infinity` fails. `r hincrbyfloat hfoo field +inf` returns
`ERR increment would produce NaN or Infinity` instead of `*value is NaN or Infinity*`.
The same path leaves the key created on a failed request, which is the bug the fix targeted.
The other 74 oracle cases pass.
