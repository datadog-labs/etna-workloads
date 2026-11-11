# Rationale
Both changed hunks are in src/src/cmd_context/cmd_context.cpp and trace to FIX.diff's cmd_context.cpp hunks in
cmd_context::insert(symbol, func_decl*) and cmd_context::insert(symbol, arity, domain, expr*). The fix added
builtin_signature_collides checks that throw cmd_exception when a declaration/definition has the same argument sorts as a
built-in. I removed those two throw blocks (restoring the pre-fix state where the check was disabled), so declarations like
(declare-fun and (Bool Bool) Int) are silently accepted. The helper itself (and the transcendental shadow no-op) is kept.
smt2print_parse fails at its test_builtin_signature_clash ENSURE(is_error).

check.sh output:
FAIL smt2print_parse (rc=114)
