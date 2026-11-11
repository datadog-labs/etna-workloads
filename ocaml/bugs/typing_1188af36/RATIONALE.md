# Rationale
Fix: "Fix some bugs in short-paths" – wrapped the `Wrong_name` and `Undefined_method`
error printers in `Printtyp.wrap_printing_env ~error:true env` so short-paths applies.

Changes, all in ocaml/typing/typecore.ml:
1. `report_error` `Wrong_name` case: removed the `Printtyp.wrap_printing_env ~error:true env (fun () -> ...)`
   wrapper (now `begin ... end`). Reverses hunk `@@ -5182,29 +5183,30 @@ let report_error ~loc env = function`.
2. `Undefined_method` case: same wrapper removed. Reverses hunk `@@ -5219,14 +5221,15 @@ let report_error ~loc env = function`.
3. The final toplevel `report_error ~loc env err` wrapper, which in today's code wraps every
   error in `wrap_printing_env` (it would mask 1 and 2), was reduced to a plain call.
   This is the today's-code equivalent of the original absence of the environment wrapping.

Build/test: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: tests/typing-short-paths/errors.ml fails (prints `M.t` instead of `t`, `M.c` instead of `c`).

RESULT: injected
