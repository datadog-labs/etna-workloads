# Re-introduced bug: wrong assert message when `try {` precedes the assertion on the same line

Upstream 3c0131a4 fixed `assert.ok(0)` inside `try { assert.ok(0);` (same-line left brace), where the
generated message contained wrong source text. In v26.13.0 the old `parseCode` in lib/assert.js is gone;
the message is now derived by `getFirstExpression` in lib/internal/errors/error_source.js (a tokenizer scan).
The bug is re-expressed there: the scan wrongly treats a `try` keyword followed by `{` as the start of a
member-access expression, so the message becomes `try { assert.ok(0)` instead of `assert.ok(0)`.

## Hunks (lib/internal/errors/error_source.js)
1. `memberAccessTokens` gains `'{'`. Corresponds to the fix's hunk replacing the loop that resumed parsing
   from the wrong position after the left brace with a token-by-token scan; reverting it again lets the `{`
   be absorbed into the expression start.
2. The member-access condition also accepts `lastToken.type.keyword === 'try'`, so `try {` is memoised as the
   first member-access token (the old code likewise started the expression at the `try`/brace text).
   Only the `try {` case is affected; `catch (err) {` and `function f() {` still give correct messages.

## Failing test
`parallel/test-assert` fails (stable across 2 runs), at test/parallel/test-assert.js:839:
```
+ message: 'The expression evaluated to a falsy value:\n\n  try { assert.ok(0)\n'
- message: 'The expression evaluated to a falsy value:\n\n  assert.ok(0)\n'
```
Note: this is a re-expression, not a literal reversal, since the original code no longer exists.
