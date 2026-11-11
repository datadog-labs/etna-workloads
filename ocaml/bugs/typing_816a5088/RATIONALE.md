# Rationale

Bug: #8856/#8860, stack overflow when printing cyclic type expressions in error messages, because the printer did not mark loops.

## Hunk
`ocaml/typing/typecore.ml`, `report_error`, case `Private_type ty`:
`Printtyp.type_expr` -> `Out_type.prepared_type_expr`.
The printer is now called without marking loops (the pre-fix state, where `type_expr` did not mark loops itself).
This reverses the `typing/printtyp.ml` hunk `@@ -1097,12 +1097,13 @@ and tree_of_typfields sch rest = function` (`type_expr` now marks loops itself via `reset_and_mark_loops`).
The test it breaks is the one added in `testsuite/tests/typing-misc/printing.ml` (`@@ -55,6 +55,20 @@`, `X zeros` with a private type).
Today's code has no `marked_type_expr`, so this is the closest re-expression.

## Commands
`make -j8 && make -j8 ocamltest && sh run-oracle.sh`: printing.ml failed (expect killed, exit -9), error_messages.ml and poly.ml passed.
Final `make clean && make -j8 && make -j8 ocamltest` then `run-oracle.sh`: printing.ml failed, the other two passed.
