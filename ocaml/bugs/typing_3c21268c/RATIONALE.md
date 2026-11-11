# Rationale
One hunk, utils/warnings.ml, `Disambiguated_name s` case in the message printer: restored the old text
"this use of X required disambiguation." in place of "relies on type-directed disambiguation, it will not compile with OCaml 4.00 or earlier."
Reverses fix.diff hunk `@@ -400,7 +400,8 @@ let message = function`. (The descriptions-table hunk at `@@ -547,7 +548,7 @@` is not present in today's code in the same form, so it was left alone.)
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr6872.ml and records.ml fail (warning 42 text mismatch).
