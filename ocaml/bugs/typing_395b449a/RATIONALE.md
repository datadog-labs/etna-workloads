# Rationale
Hunk: ocaml/typing/value_rec_check.ml (Texp_record case). The extended expression `eo` in `{ e with ... }` was checked with `option expression eo << Dereference`; now `option expression eo` (no Dereference), reversing fix hunk `@@ -441,7 +441,7 @@ let rec expression` in typing/rec_check.ml (`option expression (compos mode Dereference) eo` -> `option expression mode eo`). The copy source is thus wrongly accepted in let rec.
Commands: make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh -> letrec-check/records.ml fails (segfault, exit -11).
