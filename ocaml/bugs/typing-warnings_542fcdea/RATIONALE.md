# Rationale
Hunk: ocaml/utils/warnings.ml, `message` case `Unused_extension (s, is_exception, complaint)`.
Now ignores the is_exception flag and always says "extension constructor" (previously "exception" for exceptions).
Reverses the fix.diff hunk `@@ -369,16 +369,21 @@ let message = function` in utils/warnings.ml (which introduced the is_exception kind wording for Warning 38).
Only the message wording was reverted; the type/env plumbing is left alone (minimal).

Commands: `make clean && make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`.
Result: unused_types.ml => failed (output differs from reference: "exception X" printed as "extension constructor X").
