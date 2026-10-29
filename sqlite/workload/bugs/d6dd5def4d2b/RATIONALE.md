# Rationale

The fix made getNextToken() look for bracket characters in the text that
precedes (or replaces) a token, so a `(` or `)` preceded by non-token,
non-whitespace characters (e.g. `blah.)`) is still handled. In 3.54.1 that
job is done by `findBarredChar()` in `ext/fts3/fts3_expr.c`, which getNextToken()
uses in two places.

## Change (ext/fts3/fts3_expr.c, getNextToken)

I removed the `findBarredChar()` call in the `rc==SQLITE_DONE` branch. This
reverses the fix's `rc==SQLITE_DONE` handling (`if( rc==SQLITE_DONE ) iStart = n;`
followed by the scan for `(` and `)`). Without it, when the tokenizer finds no
more tokens, such as in `.)`, the whole remaining buffer is consumed. A `)`
hidden behind punctuation is then swallowed, `nNest` is never decremented, and
the bracket is never seen. This is the pre-fix behaviour.

The `rc==SQLITE_OK` branch is unchanged. With the `simple` tokenizer, brackets
are delimiters and are never gobbled into a token.

## Oracle failures

fts3expr-8.1 to 8.8 fail with "Error parsing expression". These are the cases
the fix added: `(blah.)`, `(blah,)`, `(blah!)`, `(blah-)`, the nested forms, and
`(,(blah-),)`. The other oracle cases still pass.
