# Rationale
Fix hunk reversed: `@@ -1203,13 +1203,13 @@ and components_of_module_maker` in typing/env.ml
(`store_module None id path md` replaced by `store_module None id (Pident id) md`).
In today's code `store_module` always uses `Pident id` for the components it computes.
Changes in ocaml/typing/env.ml:
- `store_module` gets an optional `?path` argument, used (instead of `Pident id`) as the path for `components_of_module`; default stays `Pident id`.
- In `components_of_module_maker`, the `SigL_module` case passes `~path` (the enclosing module's path), as the old code did.
(The type/modtype hunks have no effect today: those stores no longer take a path.)
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: tests/typing-modules/aliases.ml fails (it passes on the release).
