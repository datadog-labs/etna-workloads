# Rationale
Hunk: ocaml/typing/typecore.ml, in type_pat's `Ppat_open` case: `!type_open Asttypes.Fresh` changed to `Asttypes.Override`.
Reverses fix.diff hunk `@@ -1853,7 +1853,7 @@ let contains_gadt env p =` (Override -> Fresh). The code has moved since; the pattern-open `type_open` call now lives in type_pat. With Override, the local open in a pattern never gets unused-open warning tracking, so the warning 33 for `let f M.(x) = x` is lost (the PR#7443 area).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> w33.ml failed. Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: w33.ml failed (check-ocamlc.byte-output differs from reference).
