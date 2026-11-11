# Rationale
One hunk, in ocaml/lambda/matching.ml, function `can_group`: removed the `Construct { cstr_tag = Cstr_extension (p1, _) }, Construct {... p2 ...} -> Path.same p1 p2` case (and its comment about rebinding). Extension (exception) constructors are now grouped together like ordinary constructors, even though rebinding means distinct names may be equal.
This reverses the fix.diff hunks `@@ -161,11 +163,23 @@ let ctx_matcher p` / split_naive, which made exception patterns be treated naively (PR#5788). In today's code the equivalent logic is this can_group case.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: tests/basic/patmatch.ml fails (bytecode and native output differ from reference).
