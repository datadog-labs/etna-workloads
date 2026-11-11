# Rationale
Hunk: ocaml/typing/ctype.ml, `match_class_declarations`: removed the final
`match_class_types ~trace:false env (clty_params ...) (clty_params ...)` check
(and its comment) and return `[]` after the `equal_clsig` check, as before the fix.
Reverses fix.diff hunk `@@ -2714,8 +2719,14 @@ let match_class_declarations ...`, which added
the moregeneral recheck of class parameters (PR#4824). (The old `equal_clty` is
`equal_clsig` in today's code.) Class params/instance vars can again be instantiated
separately, so pr4824a_bad.ml compiles instead of being rejected.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: pr4824_ok passed, poly passed, pr4824a_bad FAILED.
