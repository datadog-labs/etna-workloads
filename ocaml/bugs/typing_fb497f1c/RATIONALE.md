# Rationale
One hunk, ocaml/typing/includecore.ml, `extension_constructors`.
Reverses fix.diff hunk `@@ -364,20 +364,22 @@ let extension_constructors ...`: the fix compares constructor arguments
against the return types (when both are GADT-style) instead of the extension's type params.
Today's code does this via Variant_diffing.compare_constructors. I reintroduced the old behaviour:
args are compared with the ext_type_params (passing None None for return types), and the return
types are then compared separately. Result: `type ('a,'b) bar += A : 'd -> ('c,'d) bar` is wrongly accepted
against `A : 'c -> ('c,'d) bar` (unsound).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> extensions.ml failed.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh -> extensions.ml failed.
