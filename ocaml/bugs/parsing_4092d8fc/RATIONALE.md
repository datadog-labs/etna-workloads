# Rationale
Today's code computes the quoted-extension id location in the lexer (`compute_quoted_string_idloc` in parsing/lexer.mll), not in parser.mly's `mk_quotedext`. The fix fixed `mk_quotedext ~loc ~shift` (hunk `@@ -418,8 +418,18 @@ let wrap_sig_ext`, plus the `~shift:2`/`~shift:3` call-site hunks) so the id location covers only the id. I reverted this by making `compute_quoted_string_idloc` return the whole token location instead of the shifted id span. No parser.mly or boot parser change was needed.
Result: tests/parsing/quotedextensions fails (error location is the whole `{%%M.foo| ... |}` token rather than `M.foo`).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> "=> failed".
