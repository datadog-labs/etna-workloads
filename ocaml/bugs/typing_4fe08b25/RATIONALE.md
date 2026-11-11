# Rationale

## Hunk changed

**File:** `ocaml/typing/typedecl.ml`, function `check_recmod_typedecl`

I removed the final `check_coherence env loc path decl` call and the comment above it.
The function now stops after `check_regularity ~abs_env env loc path decl to_check`.
Without that call, type declarations in recursive-module signatures are no longer checked
for coherence. So a signature such as `S with type x = int and type y = bool`, where
`type u = t = E of y` re-exports `t = E of x`, gets accepted. That gives an unsound
signature that can be used to convert any type into any other (#7851).

This reverses the fix.diff hunk
`@@ -1564,7 +1564,10 @@ let check_recmod_typedecl env loc recmod_ids path decl =`
in `typing/typedecl.ml`, which added the `check_coherence` call.

The other hunks changed `Ident.t` to `Path.t` in the signatures of
`check_coherence` and `Includecore.type_declarations`. Today's code depends on that
`Path.t` interface in other places (for example `typemod.ml` calls
`check_coherence ... path ...`), so I left those hunks as they are. Only the change that
affects behaviour was reverted.

## Build and test
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`: build OK;
  pr7818.ml failed, pr7851.ml failed. The expect output differs because the recursive
  module is now accepted instead of rejected with "This variant or record definition does
  not match".
- Final run: `make clean && make -j8 && make -j8 ocamltest` gave build=0. Then
  `sh run-oracle.sh` gave pr7818.ml => failed and pr7851.ml => failed.

RESULT: injected
