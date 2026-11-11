# Rationale

Hunk: ocaml/typing/typemod.ml, `Psig_exception` case of `transl_signature`: the exception is now registered
with `Signature_names.check_typext ~info:(`Shadowable ...)` instead of the default `Exported`, so a repeated
`exception Foo` in a signature silently replaces the earlier one (no "Multiple definition" error).

Reverses/relates to fix.diff hunk `@@ -483,7 +491,8 @@ and transl_signature env sg =`
(the `if List.exists (Ident.equal id) (get_exceptions rem) then rem else Sig_exception ...` dedup of
exceptions in signatures). Caveat: in today's code the upstream behaviour was later changed so that duplicate
exceptions are an error (the Test.ml expectation says "duplicated exception name is now an error"), so the
only way to make the oracle test fail is to restore the dedup-of-exceptions behaviour from the fix's logic
via Shadowable. The other fix hunks (remove_duplicates for include) are already subsumed by Signature_names.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
Test.ml => failed (expected Multiple definition error, got `module type S = sig exception Foo of bool end`).

RESULT: injected
