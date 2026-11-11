# Rationale
File: ocaml/typing/typemod.ml, function `modtype_of_package` (one hunk).
Reverses fix.diff hunk `@@ -2038,9 +2038,11 @@ and package_constraints env loc mty constrs =`, which made the
package constraint types go through `Ctype.correct_levels` (today `Ctype.duplicate_type`) so they are generic.
In today's code Subst always copies types, so removing only the duplicate_type call has no effect (tested: test still passed).
So the hunk removes both the duplicate_type call and the following `Subst.modtype Keep Subst.identity` copy; the module type is
built straight from the un-generalised constraint types. The comment was dropped too.
Result: packed_module_levels.ml fails (second expectation: "The type foo = int is not equal to the type int").

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> failed; final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh -> failed.
