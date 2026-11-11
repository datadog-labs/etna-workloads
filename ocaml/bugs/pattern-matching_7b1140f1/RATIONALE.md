# Rationale

Fix: GPR#1425 / MPR#6394 (typing/parmatch.ml, `get_type_path` -> `get_constructor_type_path` returning
`Ok | Inconsistent_environment` instead of a fatal error). In 5.5.2 parmatch.ml already uses
`get_constructor_type_path` with `assert false` (the fix's tolerant variant was already removed by later refactoring),
yet the test passes because `Mtype.enrich_typedecl` guards with `Ctype.mcomp`, so the incoherent equation
`t = X.t` (X.t = int * bool) never gets into the environment. The only way to re-expose the bug is to drop that guard.

## Hunk
- `typing/mtype.ml`, `enrich_typedecl`: removed the `Ctype.mcomp` compatibility check (and the now-unused
  `orig_ty`/`new_ty` reify bindings; `id` renamed `_id`), so the manifest `X.t` is always added even for
  incompatible declarations. This re-creates the "recursive module adds incoherent equations into the
  environment" situation that the fix's hunks in `typing/parmatch.ml`
  (`@@ -124,11 +124,24 @@ let clean_copy ty`, `should_extend`, `build_other`, `collect_paths_from_pat`) were tolerating.
  Those parmatch hunks are already absent in today's code (it uses `assert false`), so they need no edit;
  the mtype change is the closest re-expression. Note the failure now surfaces as an assertion in
  `Parmatch.get_constructor_type_path`-like code path / typecore.ml:1287 rather than Parmatch's fatal_error.

## Commands
- `make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh` -> pr6394.ml => failed (Uncaught exception: Assertion failed).
- Final `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh` -> pr6394.ml failed.
