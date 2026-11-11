# Rationale
One hunk, in `ocaml/typing/shape_reduce.ml` (App case of `reduce`): replaced
`reduce env body |> reset_uid_if_new_binding` with `reduce env body |> improve_uid`,
where a local `improve_uid` only sets the application's uid when the result has none.
This reverses fix.diff hunk `@@ -370,8 +370,7 @@` of typing/shape.ml (`improve_uid t.uid` -> `{ (reduce env body) with uid = t.uid }`),
re-expressed in the code now in shape_reduce.ml.
The typecore.ml hunk (`@@ -3955,10 +3955,12 @@`) has no counterpart in today's code (let-module code moved), so it was not reverted.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> comp_units.ml failed (App_proj_indir uid differs);
final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh -> failed.
