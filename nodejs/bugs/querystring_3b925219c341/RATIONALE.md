# Re-introduced bug: querystring unescape mishandles a '%' before a non-hex char

**Bug.** In `unescapeBuffer` (lib/querystring.js), when a `%` is followed by an invalid hex digit, or by a valid hex digit and then an invalid one, the decoder consumes the characters after the `%` without re-examining them. As a result a `%` that directly follows another `%` (or that sits in the second position of a bad escape) is never treated as the start of a new escape. `%%2a` decodes to `%%2a` instead of `%*`, and `%2%2af%2a` is also wrong.

**Hunks** (both in `lib/querystring.js`, in `unescapeBuffer`):

1. Removed the `continue;` after `out[outIndex++] = 37` in the `!(hexHigh >= 0)` branch. This matches the fix's added `continue`. Without it, execution falls through to `out[outIndex++] = currentChar; index++`. The char after `%` is copied verbatim and skipped, so a second `%` there is never re-scanned.
2. In the `!(hexLow >= 0)` branch, replaced `index--;` with `out[outIndex++] = currentChar; currentChar = nextChar;`. This matches the fix's replacement of those lines. The old code copies both chars after `%` verbatim, so a `%` in the second position is lost.

**Failing test.** `parallel/test-querystring` fails on the `qsUnescapeTestCases` entry `['%%2a', '%*']`:
```
actual: '%%2a',
expected: '%*',
```
The failure was stable across two runs. The build succeeded.
