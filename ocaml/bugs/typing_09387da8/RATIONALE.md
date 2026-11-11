# Rationale

Hunk (ocaml/typing/ctype.ml, `local_non_recursive_abbrev` and its wrapper) reverses fix.diff hunk
`@@ -1660,7 +1660,8 @@ let rec local_non_recursive_abbrev visited env p ty =`, which replaced
`let local_non_recursive_abbrev = local_non_recursive_abbrev (ref [])` (a visited-list ref shared across
all calls through partial application) with a wrapper creating a fresh ref per call.
In today's code the visited list was an immutable list passed per call, so I re-expressed the old
behaviour: `visited` is now an `int list ref` and the wrapper passes one global `visited_abbrev = ref []`
shared by all calls, so types visited in earlier checks are wrongly skipped later (begin/end added for precedence).

Tests: `make clean && make -j8 && make -j8 ocamltest` succeeded; `sh run-oracle.sh` reports
pr6174.ml => failed (expect output differs: wrong typing result instead of "Recursive local constraint").

RESULT: injected
