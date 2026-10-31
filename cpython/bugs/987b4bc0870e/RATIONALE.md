# Rationale

## Change
`tree/Python/ast.c`, `validate_stmt`, `TypeAlias_kind`: removed the
`if (stmt->v.TypeAlias.name->kind != Name_kind) { TypeError "TypeAlias with non-Name name" }`
check. This is exactly the one implementation hunk of the fix (the check is still
present verbatim in v3.15.2, so reversing it directly restores the bug). Without
it, `validate_expr(name, Store)` accepts e.g. a Subscript, and codegen later
reads `name->v.Name.id` from a non-Name node, which crashes.

## Oracle
`test_compile.TestSpecifics.test_compile_invalid_typealias` fails (no TypeError
raised / interpreter crashes), and the crash aborts the run, so later cases in
test_compile.py are reported as failing too (incomplete run).
