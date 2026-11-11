# Rationale

Changed hunk: src/src/parsers/smt2/smt2parser.cpp, `pop_quant_frame`, branch `fr->m_kind == choice_k`.

Traces to FIX.diff hunk `@@ -2140,10 +2141,7 @@` in smt2parser.cpp. The fix replaced
`throw default_exception("parsing of choice expressions is NYI")` with
`expr_stack().push_back(array_util(m()).mk_choice(new_q))`. I restored the throw, so
`(choice ((x T)) phi)` is again rejected as NYI. That is the original bug: SMT-LIB choice
terms could not be parsed. The other hunks of the fix (array plugin, solvers) are already
in the release's code and are unused without the parser path. The `array_decl_plugin.h` include
is still used elsewhere, so the tree builds.

The new test `test_ho_choice_expression` in smt2print_parse hits the error handler. test_eval then throws
"should have succeeded" and the unit aborts.

Final ./check.sh output:
    BUILD OK
    FAIL smt2print_parse (rc=134)
    ... std::runtime_error: should have succeeded
