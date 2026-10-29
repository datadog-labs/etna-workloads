# Rationale

Fix (ticket #1662): `sqlite3AtoF` and `sqlite3atoi64` began skipping leading
whitespace in text-to-numeric conversion. Reintroduced by removing it in
`tree/src/util.c`:

- `sqlite3AtoF`: removed the `sqlite3Isspace` leading-space skip (and its
  `start_of_text` label). Reverses the `while( isspace(*z) ) z++;` hunk. A
  leading space now falls into the "no number" branch, yielding 0.
- `sqlite3Atoi64`: removed `while( zNum<zEnd && sqlite3Isspace(*zNum) ) zNum+=incr;`.
  Reverses the `while( isspace(*zNum) ) zNum++;` hunk.

The trailing-whitespace handling is not part of the fix and is untouched.

## Failing oracle cases
- test/cast.test: cast-2.1, cast-2.2 (the fix's new tests: `CAST('   123' AS integer)` and
  `CAST('   -123.456' AS real)` now give 0), plus cast-5.1, cast-6.1.
- test/expr.test: expr-4.17.
