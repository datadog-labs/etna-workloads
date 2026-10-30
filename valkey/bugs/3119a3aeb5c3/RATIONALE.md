# Rationale

## Change: `src/networking.c`, `parseClientFiltersOrReply`, `ID` filter

The fix replaced the lenient parse of the `CLIENT KILL ID` argument with a
range-checked one (`getRangeLongFromObjectOrReply(..., 1, LONG_MAX, ...,
"client-id should be greater than 0")`). In 9.0.7 that check lives in the
`id < 1` test inside the `ID` loop. I removed that test, so ID values of 0 or
below are accepted again, as before the fix. `NOT-ID` is left unchanged,
because the fix only touched `ID`.

In 9.0.7 an ID of 0 goes into the ID intset and matches no client. The old
"kill everything" symptom therefore does not reappear. What returns is the
missing validation: `CLIENT KILL ID 0` and `CLIENT KILL ID -1` silently
succeed instead of returning an error.

## Oracle cases that fail

- `CLIENT KILL with illegal arguments`: `client kill id -1` returns `0`
  instead of the error `ERR*greater than 0*`.
- `CLIENT LIST with illegal arguments`: `client list id -1` returns an empty
  result instead of an error. It shares the same parser.
