# Rationale
File: ocaml/typing/parmatch.ml, `specialize_and_exhaust` (the former GADT-specific
`exhaust_gadt`/`try_many_gadt` were merged into `exhaust` since 2013).

Hunk `@@ -1025,20 +1025,16 @@ let rec try_many f = function` (try_many_gadt replaced by
`rappend`-based combiner that keeps witnesses from all constructors): reversed by replacing
the lazy flat_map over all constructor submatrices with a `try_many` that stops at the first
constructor submatrix producing a witness and keeps only that one witness (like the old
`try_many`, which dropped the remaining witnesses). When that witness is ill-typed
(filtered by the GADT check) the real non-exhaustiveness is missed.
Other fix hunks (fresh-name in Conv, Changes, comments) are not reproducible/irrelevant in today's code.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: typing-gadts/pr5906.ml fails (warning 8 lost; output differs).
