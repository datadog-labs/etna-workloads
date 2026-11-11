# Rationale
Hunks:
1. ocaml/typing/typedecl_variance.ml, Tpackage case in compute_variance: restored
   `let v = Variance.(if mem Inv vari then full else unknown) in` instead of `Variance.(compose vari full)`.
   Reverses fix hunk `@@ -88,9 +88,7 @@ let compute_variance env visited vari ty =`.
2. ocaml/stdlib/type.ml and ocaml/stdlib/type.mli: `type !'a t` -> `type 'a t` (Type.Id.t).
   Not part of the fix; required adaptation, because stdlib/type.ml (added after the 2023 fix)
   relies on the fixed behaviour (injectivity annotation on a package type) and otherwise the build fails.
Build/test: `make clean; make -j8 && make -j8 ocamltest` (after the stdlib adaptation succeeded), then `sh run-oracle.sh`:
tests/typing-misc/variance.ml => failed (the #11869 test; `!'a t = (module s with type t='a)` rejected).
