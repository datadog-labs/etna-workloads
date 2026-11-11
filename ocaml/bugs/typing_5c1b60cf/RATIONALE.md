# Rationale
Hunk: ocaml/typing/typeclass.ml, report_error `No_overriding (_, "")`: removed the terminating "." from the message
("... explicitly marked as overriding with "!"" instead of with a trailing period).
Reverses fix.diff hunk `@@ -2173,8 +2173,8 @@ let report_error env ppf =` (typo fix adding the final period; message text has since been extended, so the period after the last fragment was dropped).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean` rebuild then run-oracle: typing-objects/errors.ml fails.
