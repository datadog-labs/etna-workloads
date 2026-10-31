# Rationale

Fix (gh-130139) added `PyAst_CheckMode()` and called it in `builtin_compile_impl`'s
unoptimized-AST path (`(flags & PyCF_OPTIMIZED_AST) == PyCF_ONLY_AST`), so
`ast.parse(<wrong root node>, optimize=False)` raises TypeError.

In v3.15.2 that path now runs `PyAST_obj2mod()` (which does the mode check inside
`PyAst_CheckMode`) for all ONLY_AST cases. I restored the pre-fix behaviour in
`Python/bltinmodule.c`: for the unoptimized case, free the arena and return `source`
as-is without calling `PyAST_obj2mod`, so no node-type check is made. The optimized
path is unchanged (`syntax_check_only` is now constant 0 there).

Oracle failures: `test_ast.test_ast.AST_Tests.test_parse_invalid_ast` (TypeError not
raised for `ast.parse(ast.Constant(42), optimize=-1)`), plus one more failure in test_ast.
