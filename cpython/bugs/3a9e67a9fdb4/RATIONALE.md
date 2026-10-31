# Rationale (gh-115376)

Bug: `compiler_codegen` entered the anonymous module scope and, on a body error, exited it itself. `_PyCompile_CodeGen`'s `finally` then exited the scope again with no scope left, so `_testinternalcapi.compiler_codegen` segfaulted on bad input such as `return 42`.

In v3.15.2 scope entry lives in `compiler_codegen` (Python/compile.c) via `_PyCodegen_EnterAnonymousScope`. The fix moved scope entry and exit out of `compiler_codegen` and into its callers, so each caller owns the scope.

Changes, both in Python/compile.c:
1. `compiler_codegen`, `Module_kind`: on `_PyCodegen_Module` failure, call `_PyCompile_ExitScope(c)` before returning ERROR. This reverses the fix hunk that removed `compiler_exit_scope(c)` from that error path.
2. `_PyCompile_CodeGen` `finally`: drop the `if (c->u != NULL)` guard around `_PyCompile_ExitScope(c)`. The fix made this exit unconditional because the caller entered the scope. The guard is what currently protects against the double exit, so removing it restores the crash.

`compiler_mod` is unchanged. Its `c->u != NULL` guard still covers the double exit there.

Oracle: `test_syntax_error__return_not_in_function` now crashes the interpreter. Compiling `return 42` fails in codegen, the scope is exited twice, and `_PyCompile_ExitScope` dereferences NULL `c->u`. `check.sh` reports it as an incomplete run (crash). The other four oracle cases are listed as passing, but they come from that same crashed run, so I didn't check them separately.
