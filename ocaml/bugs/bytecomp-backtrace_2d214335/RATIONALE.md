# Rationale
Hunk: ocaml/bytecomp/bytegen.ml, removed the line `| Lprim(_,args,_) -> Event_return (List.length args)` in comp_expr's Event_after info match.
Reverses fix.diff hunk `@@ -904,6 +904,7 @@ let rec comp_expr env exp sz cont =`. Primitive calls now get Event_other, so debug info is dropped after C calls.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> tests/backtrace/event_after_prim.ml fails in bytecode (backtrace differs from reference); native passes.
