# Rationale

Fix (#6922/#8955): `@@ -875,6 +879,11 @@ class_structure` in typing/typeclass.ml added
"ensure inherited methods are listed too" so that inherited methods are also
handled when the spine of method types is generalized (needed for -principal).
Today's code does this in `Ctype.generalize_class_signature_spine`, which maps
over all of `sign.csig_meths` (inherited ones included).

Hunks (all re-expressing that one hunk of the fix, undone):
- typing/ctype.ml / ctype.mli: `generalize_class_signature_spine` takes a predicate
  and only copies the spine of methods for which it holds (previously all methods).
- typing/typeclass.ml: `class_fields_first_pass` also returns `local_meths`;
  `class_structure` passes a predicate so that methods inherited from a concrete
  same-unit parent class (single-inherit, non-virtual enclosing class) are no longer spine-generalized.
  The predicate is deliberately narrow: the ocamldoc build uses -principal
  (the other fix hunk, ocamldoc/Makefile, is already present in the release), and a broad
  regression would stop the tree from building.
Result: `class d = object (self) inherit c method n' = self#m () end` gives
warning 19 under -principal again, so typing-poly/poly.ml (expect, principal mode) fails.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), `sh run-oracle.sh`:
pr6922_ok.ml passed; poly.ml failed.
