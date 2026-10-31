Reproducer calls `_testinternalcapi.compiler_codegen` on the AST of `return 42`
(the failing upstream test, minus the test framework).

Clean: raises SyntaxError "'return' outside function"; prints `... None 1 10`, exit 0.
Buggy: the error path in codegen exits the scope wrongly, so the interpreter segfaults (exit -11).
