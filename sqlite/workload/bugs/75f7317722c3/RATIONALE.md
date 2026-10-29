# Rationale

## Changed hunk
`tree/ext/misc/regexp.c`, `re_compile()`: restored `if( pRe->aOp[0]==RE_OP_ANYSTAR ){`
(removed the `&& !noCase` guard).

This reverses fix hunk 1. The literal-prefix optimization (zInit/nInit) is again
built even for case-insensitive patterns, so `re_match()` does a case-sensitive
scan for the prefix when the pattern is compiled with `noCase`.

The other fix hunks (passing `sqlite3_user_data(context)!=0` as noCase and registering
`regexpi`) are left in place. Reverting them would remove the feature, not
reintroduce the optimization bug, and the oracle tests use `regexpi`.

## Oracle failures
`./check.sh`: 2 of 102 fail, `regexp1-1.1.2` and `regexp1-1.1.3`.
- `regexpi('abc','ABC')` and `regexpi('ABC','ABC')` return 0 instead of 1. The
  literal prefix is matched case-sensitively, so a case-insensitive match is missed.
