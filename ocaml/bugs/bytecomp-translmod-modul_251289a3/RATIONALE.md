# Rationale
All edits are in `ocaml/lambda/translmod.ml` (today's location of bytecomp/translmod.ml).

1. `Tstr_module` in `transl_structure`: `Llet(pure_module mb.mb_expr, ...)` -> `Llet(Strict, ...)`.
   Reverses fix hunk `@@ -339,16 +342,11 @@ and transl_structure ...` (Strict replacing `pure_module mb.mb_expr`).
2. `Tstr_include` in `transl_structure`: `Llet(pure_module modl, ...)` -> `Llet(Strict, ...)`.
   Reverses `@@ -378,7 +376,7 @@ and transl_structure ...`.
3. `transl_toplevel_item`, `Tstr_exception`: the exception-rebind translation gets `Env.initial` instead of `item.str_env`.
   This reverses `@@ -733,7 +737,7 @@ let transl_toplevel_item item` (`transl_ident_path item.str_env path` -> env-less `transl_path path`).
   Today, `transl_path` needs an environment to find the address, so the env-less form becomes `Env.initial`.
   Rebinding through a module alias (`module Q = Queue;; exception QE = Q.Empty`) now fails with "Cannot find address for: Q.Empty".

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: tests/typing-modules/aliases.ml fails (Fatal error: Cannot find address for: Q.Empty).
