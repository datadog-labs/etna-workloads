# Rationale

fix.diff is a large merge (4.01.1 -> trunk). The only part exercised by the oracle test
(typing-fstclassmod/fstclassmod.ml) is the Changes entry / test addition for
"PR#6194: Incorrect unused warning with first-class modules in patterns" (the test's
final `f` with `Some (module M : S3) when M.x`, expected output `2`). The code hunks of the
diff itself (`@@ -189,7 +189,7 @@ let rec modtypes` in typing/includemod.ml, lexer, main_args,
debugger) are cosmetic or unrelated, so the PR#6194 bug was re-introduced in today's code
(the nearest equivalent; this is a best-effort mapping, not a literal reversal).

## Hunks (all in typing/typecore.ml)
1. `add_module_variables`: new optional args `?(check=true) ?(fresh=false)`; `~check` is passed
   to `Env.add_module_declaration` and `md_uid` is a fresh uid when `fresh`.
2. In `type_cases`, the `when` guard env gets module variables with `~check:false`, while the
   body env gets them separately with a fresh uid. A module used only in the guard is then
   reported as unused (the PR#6194 symptom).
   Reverses the fix's change to the test/Changes for PR#6194 ("Incorrect unused warning with
   first-class modules in patterns", Changes hunk `@@ -78,10 +78,25 @@ Bug fixes:`).

## Commands
`make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> fstclassmod.ml => failed
(warning 60 unused module M as error).
