# Rationale

All changes are in `tree/src/bitops.c`.

## bitcountCommand (fix hunks 1-3)
- The two lookups (range branch and `argc == 2` branch) go back to
  `lookupKeyReadOrReply(c, key, shared.czero)` plus `checkType`. This reverses the
  "Lookup, check for type" hunks.
- The `if (o == NULL) addReply(czero)` block after the argument parsing is removed.
  It was added by the fix, and the early reply makes it dead code.
- In 9.0.7 the range branch already parses start/end/BIT before the lookup, so the
  restored code still replies 0 for a missing key once the arguments are valid.
  No BITCOUNT oracle case fails: the pre-fix BITCOUNT ordering is already covered by
  the argument parsing that precedes the lookup in 9.0.7. The restored code is the
  pre-fix lookup form and is harmless.

## bitposCommand (fix hunks 4-7)
- The early lookup is restored before the range parsing. A missing key replies
  `bit ? -1 : 0` immediately, then `checkType` and `getObjectReadOnlyString` run.
- The three late lookups added by the fix are removed: the range branch, the
  `argc == 3` branch, and the `o == NULL` reply after parsing.
- `totlen`, the overflow assert and `end` defaulting stay as they are, since they
  only needed the string length.

## Oracle failures
- `BITPOS will illegal arguments`: `bitpos s 0 1 hello hello2` on a missing key
  returns 0 instead of a syntax error.
- `BITPOS against non-integer value`: `bitpos s 0 a b` on a missing key returns 0
  instead of "not an integer".
- `BITPOS against wrong type` was not caught: the pre-fix type check already
  returned WRONGTYPE in the cases the test uses.
