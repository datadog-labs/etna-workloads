# Rationale

Hunk changed: `tree/Python/ast.c`, `validate_expr`, `case NamedExpr_kind`.
Reverses the fix's only implementation hunk: removes the check that
`NamedExpr.target->kind == Name_kind` (and the TypeError "NamedExpr target must be a Name").
The code is identical to the pre-fix logic, so only the value is validated.

Oracle: `test_compile.TestSpecifics.test_compile_invalid_namedexpr` fails. Compiling an AST with a
non-Name NamedExpr target inside a ListComp no longer raises TypeError and crashes the
interpreter (the run aborts; the other listed failures come from the crashed run being incomplete).
