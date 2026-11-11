# Rationale
Reverts fix.diff hunks (renamed-univar tracking): `Univ of type_expr` -> `Univ of string option`.
- typing/errortrace.ml, errortrace.mli: `Univ of type_expr` back to `Univ of string option` (hunks `@@ -66,7 +66,9 @@ module Unification_trace` in ctype.ml / ctype.mli, today's Errortrace).
- typing/ctype.ml: occur_univar / univars_escape raise `Univ u` with the name instead of the type (hunks `@@ -1826,9 +1828,9 @@` and `@@ -1879,8 +1881,8 @@`).
- typing/errortrace_report.ml explain_escape: prints the stored original name instead of the type, so renaming is not tracked (printtyp.ml hunk `@@ -1814,11 +1814,9 @@`).
Ran: make clean; make -j8; make -j8 ocamltest; sh run-oracle.sh -> tests/typing-poly/error_messages.ml fails (message shows 'a rather than 'a0).
