# Rationale
File: ocaml/runtime/major_gc.c, caml_orphan_finalisers.
Changed `f = domain_state->final_info = caml_alloc_final_info();` back to `domain_state->final_info = caml_alloc_final_info();`,
reversing hunk `@@ -451,8 +452,7 @@ void caml_orphan_finalisers` (the fix merged the two assignments so `f` refers to the new dummy final info).
Without it, `f` still points to the orphaned struct, so the updated_first/updated_last bookkeeping hits the wrong struct and counters are decremented wrongly.
The other fix hunks (a CAMLassert, test enablement, Changes) were not reverted. The assert is not behavioural.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`; finaliser_handover fails ("Assertion failed: old > 0" in camlatomic.h).
