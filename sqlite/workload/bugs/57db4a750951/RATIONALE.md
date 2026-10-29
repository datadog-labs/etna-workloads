# Rationale

Fix hunk (src/util.c, sqlite3AtoF): `e = e*10 + digit` became `e = e<10000 ? (e*10 + digit) : 10000`
to avoid 32-bit overflow of the exponent.

In 3.54.1 the exponent loop lives in `sqlite3AtoF()` in src/util.c (variable `exp`).
I restored the unclamped accumulation: `exp = exp*10 + v;`, replacing
`exp = exp<10000 ? (exp*10 + v) : 10000;`. Same computation as the pre-fix code.

Failing oracle cases: nan-4.34 ('2.5e2147483650' gives 0.0 instead of inf) and
nan-4.35 ('2.5e-2147483650' gives inf instead of 0.0), because the exponent wraps
around its sign.
