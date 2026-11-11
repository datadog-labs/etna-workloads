# Rationale
File: ocaml/typing/typedecl.ml, function `check_coherence`-area code that builds the constrained decl (today's equivalent of `transl_with_constraint`).
Reverses hunk `@@ -1055,11 +1055,16 @@ let transl_with_constraint ...`: the fix made the private flag come from the original
declaration when the kind is kept and the `with` is public. I removed that logic: `priv` is now just `sdecl.ptype_private`
(also dropped the now-unused `sig_decl_abstract`, and the deprecation warning that depended on it). So
`module Test2 : module type of Test with type t = Test.t` loses `private` on the variant, allowing `Test2.A`.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> private.ml fails.
