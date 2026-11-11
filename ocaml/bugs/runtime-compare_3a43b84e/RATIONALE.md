# Rationale
Hunk: ocaml/runtime/compare.c, do_compare_val. Removed the two lines
`if (t1 == Infix_tag) t1 = Closure_tag;` / `if (t2 == Infix_tag) t2 = Closure_tag;`
inside the `if (t1 != t2)` block. This reverses fix.diff hunk
`@@ -186,6 +186,8 @@ static intnat do_compare_val(...)` in runtime/compare.c.
The other fix hunk (dropping `case Infix_tag:` from the functional-value case) was
already absent-equivalent in today's code: the `case Infix_tag:` label stays; it is
harmless and I left it as is, since in the buggy original it was present too.
Result: comparing a Closure with an Infix closure returns a tag difference instead of raising Invalid_argument.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/basic/equality.ml fails
(Test 57 FAILED, bytecode and native). A `make clean` rebuild was started but hit the tool timeout;
a subsequent full `make -j8 && make -j8 ocamltest` succeeded and the oracle was re-run with the same failure.
