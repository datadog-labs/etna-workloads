# Rationale
File: ocaml/lambda/translmod.ml, `init_shape` (today's home of bytecomp/translmod.ml's init_shape).
Reverses fix hunk `@@ -199,9 +199,10 @@ let undefined_location loc =` (Mta_present/Mta_absent aliases must be treated differently in init_shape).
Today's equivalent of Mta_absent/Mta_present is Mp_absent/Mp_present in Sig_module. Changes:
1. `Mty_alias _` now returns `Const_block (1, [const_int 0])` instead of raising Initialization_failure (all aliases compiled as in the pre-fix code).
2. `Sig_module(..., Mp_absent, ...)` is no longer skipped; it is merged with the Mp_present case so absent aliases also get a shape entry (pre-fix: no present/absent distinction).
Result: recursive module T2 gets a shape field for absent alias N, so CamlinternalMod asserts (Assert_failure camlinternalMod.ml 81).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/typing-modules/pr7787.ml => failed.
