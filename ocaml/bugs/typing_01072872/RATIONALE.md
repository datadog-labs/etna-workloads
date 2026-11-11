# Rationale
One hunk, ocaml/typing/typecore.ml, in `report_error` for `Wrong_name`.
It removes the "This record/variant ... expression is expected to have type T" intro line and the
"The field x does not belong to type T" wording, restoring "The record type T has no field x".
Reverses fix.diff hunk `@@ -3643,10 +3667,13 @@ let report_error env ppf = function`
(the Wrong_name printing). The wrap_disambiguate/type-carrying hunks are already
represented in today's code differently (Wrong_name carries type_expected); the payload is left unused (`_eorp`, `_ty_expected`).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-warnings/records.ml (and gadts test) fail.
