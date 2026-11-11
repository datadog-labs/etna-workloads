# Rationale
One hunk, ocaml/typing/env.ml (spellcheck, Ldot case): removed the custom pp (printing full Longident.Ldot) passed as ~pp to Misc.did_you_mean, so only the bare name is hinted.
Reverses fix hunk "@@ -3543,7 +3548,8 @@ let spellcheck ppf extract env lid =" in typing/env.ml. Other hunks (optional ?pp parameter, tests) left in place; harmless.
Commands: make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh -> spellcheck.ml failed (hint shows "protect" not "Fun.protect").
