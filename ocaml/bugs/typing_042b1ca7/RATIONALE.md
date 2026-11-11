# Rationale
File typing/typemod.ml, function `package_constraints_sig`, Sig_module case: the pattern now ignores the
module presence (`Sig_module (id, _, md, rs, priv)`) and rebuilds the item with `Mp_present`, instead of
preserving `pres`. This reverses the hunk `@@ -1797,43 +1798,43 @@ let check_recmodule_inclusion env bindings`
(the fix changed `Sig_module (id, _, md, ...)` ... `Mp_present` into `Sig_module (id, pres, ...)` ... `pres`).
Effect: aliased submodules in package types lose their Mp_absent presence, so subtyping of
`(module S with type t = int)` to `(module T)` fails (tests/typing-fstclassmod/aliases.ml fails).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> aliases.ml failed, user.ml passed;
final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: same.
