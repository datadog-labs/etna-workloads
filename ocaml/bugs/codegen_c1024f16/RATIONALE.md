# Rationale
One hunk, ocaml/asmcomp/cmmgen.ml (Uclosure case of transl): replaced
`make_alloc dbg Obj.closure_tag (transl_fundecls 0 fundecls)` with a direct
`Cop(Calloc, alloc_closure_header (List.length fields) dbg :: fields, dbg)`.
This reverses the fix hunk `@@ -1647,29 +1647,31 @@ let rec transl env e =` (which switched closure
allocation to make_alloc, which uses the major heap when size > Max_young_wosize).
Closures larger than Max_young_wosize now emit an out-of-range Ialloc.
The selectgen.ml assert hunk added by the fix was not re-removed (nothing to undo; it doesn't exist today).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh:
tests/basic-more/pr1271.ml fails (native compile fails), bytecode passes.
