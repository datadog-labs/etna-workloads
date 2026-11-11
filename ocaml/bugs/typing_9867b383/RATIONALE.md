# Rationale
- ocaml/typing/ctype.ml, `subtype_row`: removed the two lines
  `let r1 = if row2_closed then filter_row_fields false r1 else r1 in` and the symmetric r2 line.
  Reverses fix.diff hunk `@@ -4132,6 +4132,8 @@ and subtype_row env trace row1 row2 cstrs =`
  (absent fields no longer filtered when the other row is closed; MPR#7824).
- Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
  pr7824.ml fails (expect output differs).
