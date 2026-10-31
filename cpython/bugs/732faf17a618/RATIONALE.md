# gh-115347: redundant NOP for the docstring with -OO

The fix made the compiler skip the docstring statement under -OO instead of
leaving a redundant NOP. In v3.15.2, compiler.c/codegen.c no longer see the
docstring under -OO because `Python/ast_preprocess.c` removes it
(`remove_docstring`). Only a body consisting solely of the docstring is
replaced with `pass`; otherwise the statement is deleted.

## Change (Python/ast_preprocess.c, `remove_docstring`)
Always replace the docstring with a `pass` statement, never remove it. This
restores the pre-fix result, where the -OO docstring statement survived as a
redundant NOP. It reverses the fix's goal of emitting no instruction for an
omitted docstring (the `first_instr`/skip logic in `compiler_body` and
`compiler_function_body`).

## Oracle
`test.test_compile.TestSpecifics.test_docstring_omitted` fails for opt=2:
dis output of the function `h` and class `C` contains `NOP`.
