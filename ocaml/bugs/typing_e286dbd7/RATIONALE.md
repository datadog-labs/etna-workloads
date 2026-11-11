# Rationale
- ocaml/typing/typemod.ml, type_implementation: removed `Typecore.force_delayed_checks ();` in the `if !Clflags.print_types then begin` branch. Reverses fix.diff hunk `@@ -1614,6 +1614,7 @@ let type_implementation sourcefile outputprefix modulename initial_env ast =` (which added that call).
- Tests/Changes hunks not applicable.
- Ran: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: typing-ocamlc-i/pr7620_bad fails (ocamlc -i exits 0 instead of error).
