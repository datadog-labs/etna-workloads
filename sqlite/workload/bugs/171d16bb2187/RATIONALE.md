# Rationale

Fix: make `DEFAULT true/false` and `DEFAULT(true/false)` in CREATE TABLE work, by
converting the ID to TK_TRUEFALSE via `sqlite3ExprIdToTrueFalse()` in the parser
(`ccons ::= DEFAULT scantok id`) and in `exprNodeIsConstant()` (TK_ID case).

In 3.54.1 the helper and the lookupName/resolve hunks already exist and are used elsewhere
(IS TRUE, resolve.c), and the TK_TRUEFALSE struct-size hunk (dupedExprStructSize) is
obsolete (truth value is now kept in flag bits that survive reduction). So I reverted
the two call sites that implemented the DEFAULT feature:

- `src/parse.y`: removed the `sqlite3ExprIdToTrueFalse(p)` call (and its testcase) in
  `ccons ::= DEFAULT scantok id`. Reverses the parse.y hunk. `DEFAULT true` is stored as the string 'true'.
- `src/expr.c` `exprNodeIsConstant`: removed the TK_ID conversion to TK_TRUEFALSE.
  Reverses the exprNodeIsConstant hunk. `DEFAULT(true)` now fails the constant check
  / yields a non-boolean default.

Failing oracle cases: istrue-500, 510, 520-524, 700 (e.g. istrue-700 got
`1 false true false true` instead of `1 0 1 0 1`; istrue-500 defaults come back wrong/as text).
