# Rationale
Hunk: ocaml/typing/typemod.ml, `approx_constraint`, `Pwith_module`/`Pwith_modsubst` case.
Reverses fix.diff hunk `@@ -656,8 +656,21 @@ let rec approx_modtype env smty` (typing/typemod.ml), which added a module lookup in
the approximation phase so that references to a recursive module in `with module` raise an error.
Today that lookup is `Env.lookup_module` in `approx_constraint`. Now an `Env.Error` from the lookup
(illegal recursive reference) is swallowed and the constraint skipped, so the check is lost.
Result: `module rec M : S with module M := M = M` no longer gives "Illegal recursive module reference" (recursive-module error).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`:
gpr1626.ml => failed, t14bad.ml => passed.

RESULT: injected
