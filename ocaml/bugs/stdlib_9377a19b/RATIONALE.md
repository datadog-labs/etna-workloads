# Rationale
Fix reversed: "Dynarray: stick an object inside the dummy value to 'fix' comparison". Bug: dynarray dummy is a cyclic record, so structural comparison (`compare a a'`, `a <> a'`) of dynarrays loops forever.

Hunks (all in ocaml/stdlib/dynarray.ml):
1. `@@ -181,14 +181,33 @@ module Dummy` : restored `type 'stamp dummy = { mutable dummy : 'stamp dummy }` and `let rec dummy = { dummy } in` in `fresh ()`, removing the object-based dummy (and the CamlinternalOO reference). Reverses that hunk.
2. Adaptation to today's code (not a fix hunk per se): in `Dummy.Array.blit`, `src_dummy == dst_dummy` became `Obj.repr src_dummy == Obj.repr dst_dummy`. With a record type the phantom stamps are unified by `==` and the signature no longer matches; this keeps the build working. It's a consequence of reversing hunk 1.

The stdlib/.depend and StdlibModules hunks (dynarray order/dependency on camlinternalOO) were not reverted: dynarray no longer uses CamlinternalOO, and the module order is harmless/builds fine (build files are off limits anyway).

Commands: `make clean && make -j8 && make -j8 ocamltest` (succeeded), then `sh run-oracle.sh`. tests/lib-dynarray/test.ml (which already contains `assert (Stdlib.compare a a' <> 0)`) now hangs in infinite comparison and gets killed by timeout (no "passed" line; it passed before the change).

RESULT: injected
