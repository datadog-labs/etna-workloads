# Rationale

## Change
`tree/Python/codegen.c`, `compiler_lambda` (moved from Python/compile.c since the fix):
the non-generator branch emitting `RETURN_VALUE` used `LOC(e->v.Lambda.body)`.
Reverted to the pre-fix `LOCATION(e->lineno, e->lineno, 0, 0)`, reversing the single
implementation hunk of the fix (`compiler_lambda` in compile.c). The code is equivalent:
same statement in the same branch, only relocated to codegen.c.

## Oracle failures
`test.test_compile.TestSourcePositions.test_lambda_return_position` fails for all four
snippets: the RETURN_VALUE has position (1, 1, 0, 0), i.e. column 0, outside the lambda body
(`AssertionError: 0 not greater than or equal to 12`).
