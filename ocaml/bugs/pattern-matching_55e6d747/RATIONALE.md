# Rationale
Hunk: ocaml/typing/parmatch.ml, in `build_other` (polymorphic variant case, `[] ->` branch).
The fix hunk `@@ -1019,7 +1019,12 @@ let build_other ext env = match env with` replaced the constant
`make_other_pat some_other_tag true` with a computed tag (`some_private_tag` for fixed rows, otherwise a fresh
`AnyOtherTag` with apostrophes). I reverted to a single fixed tag, now named `some_private_tag`. The rename
already exists in today's code. Open rows now print `<some private tag>` instead of `AnyOtherTag`.
Other fix hunks (rename in parmatch.mli/typecore.ml, tests, Changes) need no reversal.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest`
and run-oracle.sh. Result: typing-misc/polyvars.ml fails (3 "=> failed" lines).
