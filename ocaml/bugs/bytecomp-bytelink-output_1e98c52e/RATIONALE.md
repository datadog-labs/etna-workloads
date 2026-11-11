# Rationale
One hunk, in ocaml/bytecomp/bytelink.ml (`link`): replaced the three-way `match` on nopervasives/output_c_object/output_complete_executable with the earlier if/else chain (`else if !Clflags.output_c_object then "stdlib.cma" :: objfiles`). This reverses fix.diff hunk `@@ -602,9 +603,15 @@ let fix_exec_name name =`. With -output-complete-exe, std_exit.cmo is no longer linked, so at_exit hooks do not run.
The `caml_sys_exit` hunk (`@@ -515,6 +515,7 @@`) has no equivalent in today's code (it now uses caml_do_exit(0)), so I left it alone.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. Result: output-complete-obj/test2.ml fails (missing "Program terminated").
