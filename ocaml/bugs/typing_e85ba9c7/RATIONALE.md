# Rationale
One hunk, in `ocaml/typing/typemod.ml` (`type_structure`, `Pstr_module` case):
non-generalizable type variables of a module's type were lowered to
`outer_scope` (the level before typing the module). Now they are lowered to the
module's own, newer `scope`, so they stay at a deeper level. This restores the
lax scoping that lets `Common0.q : _ Queue.t` unify with `Common0.msg Queue.t`.
I also deleted the `let outer_scope = ...` binding, which was no longer used.

It reverses the fix.diff hunk `@@ -1338,7 +1338,7 @@ let prefix_idents_and_subst root sub sg =` in typing/env.ml.
That hunk changed `Path.binding_time path - 1` to `Path.binding_time path`, the
strict nongen level. Today's code has no `set_nongen_level`. The equivalent
mechanism is `Mtype.lower_nongen`, which is called from `typemod.ml`.

Commands run:
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh`
- final `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`

Result: `pr6752_bad.ml` fails because the program that should be rejected now
compiles. `pr6752_ok.ml` passes.
