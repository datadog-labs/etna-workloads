# RATIONALE

## Bug
Header-name matching in `lib/_http_incoming.js` was supposed to treat known fields written in
any casing (e.g. `CONTENT-TYPE`, `COOKIE`, `SET-COOKIE`, `AUTHORIZATION`) by the same merge
rules as their usual spellings. The old behaviour lost the merge rule for such casings: they
were treated like unknown fields and joined with ', ' (so `CONTENT-TYPE` duplicates were
joined rather than dropped, `COOKIE` joined with ', ', `SET-COOKIE` not an array, and
joinDuplicateHeaders not specially applied).

## Change (one hunk)
In `matchKnownFields`, the final fallback `return matchKnownFields(field.toLowerCase(), true);`
is replaced by `return field.toLowerCase();`. This corresponds to the fix hunk that reworked
the fallback/return values of `matchKnownFields` (descriptor objects, lowercase retry for
other casings). The plain lowercased string is treated by `_addHeaderLine` as an unknown
field (join with ', '), reproducing the pre-fix loss of known-field semantics for non-standard casings.

## Failing test
`parallel/test-http-incoming-matchKnownFields` fails (stable over 2 runs):
`actual: { 'content-type': 'test, value' }, expected: { 'content-type': 'test' }`
(from `checkDest('CONTENT-TYPE', ...)`).
