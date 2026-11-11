# Rationale
Both hunks are in `ocaml/typing/typecore.ml`, function `type_newtype` (today's version of the `Pexp_newtype` case).

1. Fix hunk `@@ -2270,6 +2270,9 @@ and type_expect ?in_function env sexp ty_expected =` (and its matching removal at `@@ -2283,9 +2286,6 @@`) moved `let ty = newvar ()` and `begin_def ()` so that `ty` was created at the outer level. I reversed this by creating `ty` inside `with_local_level_generalize`, so it sits at the inner level.
2. The same fix moved `Ident.set_current_time ty.level`. That call set the scope of the newtype's identifier to the outer level. Today that scope is `create_scope ()`, which is the inner level plus one. I replaced it with `Ident.lowest_scope`, so the scope check no longer rejects escaping of the locally abstract type. Moving `ty` alone did not change the test result, so this change is what makes the bug show up.

Effect: `let f x (type a) (y : a) = (x = y)` and the `(type g)` method in a class are accepted. They should fail with "The type constructor a would escape its scope".

Commands run:
- `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
- Result: tests/typing-typeparam/newtype.ml fails. The output has the escape-scope errors missing and shows `val f : a -> 'a -> bool` instead.
- Before the final clean build, an incremental build with only the `ty` move passed the oracle test.
