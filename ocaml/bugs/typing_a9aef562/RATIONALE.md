# Rationale
Hunk: ocaml/typing/includemod.ml, `check_functor_application_in_path`: the argument list handed to
`Apply_error` is emptied (`List.filter (fun _ -> false) args`), so the ill-typed functor application
error no longer carries the inclusion details (the "Modules do not match ... is not included in ..." text).
Reverses fix.diff hunks `@@ -96,20 +96,32 @@ let rec narrow_unbound_lid_error` and `report_error`
(`Ill_typed_functor_application of Longident.t * Includemod.error list option`), which added the details.
In today's code that logic lives in Env/Includemod, so this is the equivalent of dropping the details.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> applicative_functor_type.ml fails;
final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh -> still fails.
