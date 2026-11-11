# Rationale

One hunk, in `ocaml/typing/out_type.ml` (`Variable_names.name_of_type`; printtyp.ml's code moved here).
It removes the `if name <> "_" then` guard, so `names := (t, name) :: !names;` is always run.
This reverses the fix.diff hunk `@@ -236,7 +236,8 @@ let name_of_type t =` in typing/printtyp.ml.
With the guard gone, the `_` name given to anonymous type parameters is recorded as taken. A later `_` parameter is then renamed to a suffixed variant, so the output shows `'_0` where it should show `_`, for example `type (_, '_0) eq`.

The other fix hunks (oprint.ml and typedecl.ml) are already in an equivalent form in the current code, so I left them alone.

Commands run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: the typing-gadts tests fail, with diffs such as `type (_, '_0) eq = Refl ...`.
