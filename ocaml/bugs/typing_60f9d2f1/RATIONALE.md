Reverts the fix for #10271 (use Env.remove_last_open for pattern opens), restoring Env.copy_local.
Hunks (partial revert; remove_last_open stays in env.ml but is unused in typecore):
- typing/env.ml: re-add `copy_local` after `lookup_error` (reverses fix hunk `@@ -603,11 +639,6 @@ let error err`, which removed it).
- typing/env.mli: re-add `val copy_local: from:t -> t -> t` (reverses `@@ -56,7 +56,6 @@ val empty: t`).
- typing/typecore.ml Ppat_open: instead of Env.remove_last_open, keep the env with the open and only copy local_constraints/flags back into the original env (reverses `@@ -2014,11 +2014,15 @@ and type_pat_aux`). The open's bindings thus leak into the rest of the pattern scope.
Tests: `make clean && make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`: typing-gadts/pr10271.ml fails.
