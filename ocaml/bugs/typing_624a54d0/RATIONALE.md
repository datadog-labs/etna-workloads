# Rationale
- typing/includemod.ml, Sig_type case in `signature_components`: `mark_error_as_unrecoverable item` -> `mark_error_as_recoverable item`.
  Reverses the fix hunk adding `let item = mark_error_as_unrecoverable item in` after `type_declarations` (`@@ -687,12 +737,14 @@ and signature_components`). Type-declaration errors no longer stop the signature difference, so later items are compared in an incoherent env (List.iter2 Invalid_argument on arity mismatch).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> distant_errors.ml failed (Uncaught exception Invalid_argument("List.iter2")).
