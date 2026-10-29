# Rationale

Fix hunk (src/util.c): `result = INFINITY;` -> `result = INFINITY*s;` — the
overflow path lost the sign, so -1e999 became +Inf.

In 3.54.1 the sign is no longer passed into the converter: `sqlite3AtoF()`
(src/util.c) calls `sqlite3Fp10Convert2()`, which returns +INFINITY on overflow,
then applies `if( neg ) *pResult = -*pResult;`. I changed that line to
`if( neg && *pResult<=1e308 )`, so the sign is dropped when the result
overflowed to infinity — same defect: negative overflow reported as +Inf.
Finite results are still negated normally.

Oracle failure: test/nan.test nan-4.40 (`cast('-1e999' AS real)`) gives `inf`
instead of `-inf`. All other oracle cases pass.
