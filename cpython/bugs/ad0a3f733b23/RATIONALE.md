# Rationale

v3.15.2 already has the `enable_warnings` parameter of `_PyAST_Preprocess`
(Python/ast_preprocess.c, pycore_compile.h), so only the call site changed.

## Python/compile.c, `_PyCompile_AstPreprocess`
Reverses the fix hunk that passes `enable_warnings=0` here (ast.parse /
`PyCF_ONLY_AST` path). It now passes 1, so the PEP 765 warnings
(return/break/continue in finally) are emitted during `ast.parse()` again, and
a second time at compile.

## Oracle failures
- `test_pyrepl.test_interact.TestWarnings.test_pep_765_warning`: the warning is
  emitted twice in the REPL (count 2 != 1).
- The new `test_compile` `test_pep_765_warnings` cases (ast.parse under
  `simplefilter("error")`) would also fail.
