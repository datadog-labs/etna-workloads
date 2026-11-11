# Rationale
One hunk, `ocaml/typing/value_rec_check.ml` (today's name for `typing/rec_check.ml`), case `Texp_apply (e, args)`.
Reverses fix.diff hunk `@@ -577,15 +577,33 @@ let rec expression`: replaced the split_args logic
(applied args Dereference, delayed args Guard, function Dereference only if some arg applied)
with the old logic: if any arg is omitted, everything is Guard, else everything Dereference.
(The Changes and test hunks were not touched.)

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
letrec-check/partial_application.ml fails (expect output differs).
