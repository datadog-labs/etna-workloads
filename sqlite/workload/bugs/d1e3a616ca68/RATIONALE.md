# Rationale

Fix (ticket #2323) made trim/ltrim/rtrim split the character set into UTF-8
characters (`sqliteNextChar`) instead of single bytes. Pre-fix, `trimFunc`
treated every byte of the set as a separate character.

Changed (tree/src/func.c, `trimFunc`): in both loops that split `zCharSet`
(the counting loop and the azChar/aLen filling loop), `SQLITE_SKIP_UTF8(z)`
(the modern form of `sqliteNextChar`) is replaced by `z++`. Each charset
entry is then one byte with length 1, which is exactly the pre-fix byte-wise
behaviour. The rest of the multi-byte-aware machinery is left intact, as in
the fix's own structure; it just sees only 1-byte entries.

Oracle failure: test/func.test func-22.16
`trim(x'ceb1ceb2ceb3', x'ceb1')` returns B2CEB3 instead of CEB2CEB3, because
bytes CE and B1 are trimmed individually (the second CE is eaten).
func-22.14/22.15 still pass (they pass byte-wise too).
