Hunk: ocaml/typing/typecore.ml, type_cases: check_partial now gets ty_arg' instead of ty_arg_check.
Reverses fix.diff hunk '@@ -3918,25 +3918,28 @@ and type_cases ...' (exhaustiveness check used the variable-copied type).
Ran: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> pr7390.ml failed (expected-output diff).
