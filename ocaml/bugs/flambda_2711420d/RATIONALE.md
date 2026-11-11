# Rationale

Build is non-flambda, so the original flambda-only fatal error cannot be reproduced literally.
The only oracle test (pr7426.ml) needs ocamlopt to fail on `class c = object val v = 0.0 end`.
I undid the fix's cmmgen hunk
`@@ -2355,6 +2370,22 @@ and transl_prim_2 ... transl_prim_3` (the new `Psetfield_computed` case in
`transl_prim_3`) in `ocaml/asmcomp/cmmgen.ml` (today the case calls `setfield_computed` from cmm_helpers).

Changes (single file, asmcomp/cmmgen.ml):
1. `transl_prim_3`: the `Psetfield_computed` case now has a guard that excludes a float-constant
   third argument. Such a store falls through to the "Cmmgen.transl_prim_3" fatal error, i.e. the
   computed set-field primitive is no longer handled for this object-instance-variable case. (A fully
   removed case broke the stdlib build because Dynarray uses an object, so the guard is narrower.)
2. Added `Psetfield_computed _` to the unreachable-primitive list of `transl_prim_3` so the match
   stays exhaustive (the fix added the case to the same function).

Caveat: this is an approximation; the guard is a narrowing of the fix's hunk, not an exact reversal.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: builds OK; pr7426.ml => failed (native: Fatal error: Cmmgen.transl_prim_3: setfield_ptr_computed); bytecode passes.
