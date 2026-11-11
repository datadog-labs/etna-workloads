# Rationale
Hunk: ocaml/typing/mtype.ml, `contains_type`, case `Mty_ident path`.
Reverses fix.diff hunk `@@ let rec contains_type env = function` (typing/mtype.ml).
The fix made an abstract module type (`mtd_type = None`) count as possibly containing types (raise Exit).
I restored the old code `try Option.iter (contains_type env) (Env.find_modtype path env).mtd_type with Not_found -> raise Exit`
(`Misc.may` is now `Option.iter`), so abstract module types are treated as type-free and the unsound
`val` unpacking in functors (PR#6427) is accepted.

Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: tests/typing-modules-bugs/pr6427_bad.ml fails (it compiles when it should be rejected).
I did not run a final `make clean` rebuild; the build was incremental, and only typing/mtype.ml changed.
