# Rationale
All edits are in ocaml/typing/value_rec_check.ml (today's name for typing/rec_check.ml).

- `value_bindings`, Recursive case (hunk `@@ -1030,22 +1043,88 @@ ... and value_bindings`): removed the `transitive_closure` fixpoint; the result is now just `Env.join_list env` (immediate dependencies Gi only, ignoring transitive deps). The `mdef` result is ignored (`_mdef`).
- `Env.compose` (sig and impl) and `Env.equal` (sig and impl), reversing hunks `@@ -369,6 +371,10 @@`, `@@ -377,12 +383,16 @@`, `@@ -397,6 +407,9 @@`: removed, as they are only used by the closure (otherwise unused-value warnings-as-errors break the build).
- `Mode.equal`, reversing `@@ -302,6 +302,8 @@ module Mode`: removed for the same reason.

Effect: `let rec wrong = let rec x = ref y and y = ref wrong in ref ("foo" ^ ! ! !x)` is accepted and segfaults.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: letrec-check/basic.ml fails (expect crashes, exit code -11).
