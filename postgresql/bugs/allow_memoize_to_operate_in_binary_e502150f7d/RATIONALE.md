# Rationale

Changed file: src/backend/optimizer/path/joinpath.c, function paraminfo_get_equal_hashops (two hunks).

Traces to the fix.patch hunks in the same function that set `*binary_mode = true`:
1. when the join operator is not hashable (`!OidIsValid(rinfo->hashjoinoperator)`)
2. for lateral Vars.

Both now set `*binary_mode = false`, so Memoize never uses binary comparison mode. It compares keys
with the hash equality operator, so values such as -0.0 and +0.0 are treated as the same cache key
even when the join operator can tell them apart. That gives wrong results. The executor and plan
plumbing is left intact.

Failing oracle cases: src/test/regress||join, ||memoize, ||subselect.
