Hunk: ocaml/lambda/matching.ml, compile_match_nonempty: pattern `{ cases = []; args = [] }` weakened to `{ cases = [] }`.
Reverses fix.diff hunk `@@ -2690,7 +2690,7 @@ let arg_to_var arg cls` (bytecomp/matching.ml, compile_match), which added `args = []`.
Effect: an empty-case matrix with remaining args discards the scrutinee (PR#7230).
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh; then final make clean + rebuild + oracle: pr7230.ml fails.
