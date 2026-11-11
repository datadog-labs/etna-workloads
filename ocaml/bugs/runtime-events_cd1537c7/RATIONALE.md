# Rationale
Fix: "fix missing EV_C_MINOR_ALLOCATED" – added the constructor to the OCaml runtime_counter type and name function.
Reintroduced by removing it again (the C enum in runtime/caml/runtime_events.h already has it today):
- otherlibs/runtime_events/runtime_events.ml: removed `| EV_C_MINOR_ALLOCATED` from the type (reverses hunk `@@ -26,6 +26,7 @@ type runtime_counter =`) and the `-> "minor_allocated"` case in runtime_counter_name (reverses `@@ -99,6 +100,7 @@ let runtime_counter_name counter =`).
- otherlibs/runtime_events/runtime_events.mli: removed the constructor and its doc comment (reverses `@@ -46,6 +46,7 @@ type runtime_counter =`).
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> test_caml_counters fails ("There is no constructor EV_C_MINOR_ALLOCATED").
