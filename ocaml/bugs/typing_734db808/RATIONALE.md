# Rationale
One hunk, in ocaml/typing/ctype.ml, function `occur`: removed the `if not (eq_type ty0 ty) then` guard so `occur_rec` runs even when ty0 == ty.
Reverses fix.diff hunk `@@ -1776,7 +1776,8 @@ let occur env ty0 ty =` (typing/ctype.ml). The other ctype/types hunks were already applied differently in today's code and left as-is.
Commands: make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh -> tests/typing-misc/constraints.ml fails.
