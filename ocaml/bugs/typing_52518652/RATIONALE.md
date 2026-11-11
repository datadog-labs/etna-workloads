# Rationale
Hunk: typing/typecore.ml, `warn_out_of_scope`: removed the `Printtyp.wrap_printing_env ~error:true env (...)` wrapper around the type path printing (env now unused, `ignore env`). Reverses fix.diff hunk `@@ -776,7 +776,9 @@ end) = struct` (typecore.ml), which added wrap_printing_env (code has since moved into warn_out_of_scope).
Other hunks (printtyp lookup options, tests, Changes) not reverted; the printtyp ones no longer exist in that form.
Commands: `make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh` (also after `make clean`); typing-misc/pr6416.ml fails (prints Bar.info rather than Bar/2.info).
