# Rationale
Hunk: ocaml/typing/typemod.ml, `package_constraints` (`Mty_ident p` case).
Fix hunk reversed: `@@ -1830,10 +1830,9 @@ let modtype_of_package env loc p nl tl =` in typemod.ml,
which removed the `assert false` on Not_found (missing cmi) and treated it like the abstract case.
In today's code that logic lives in package_constraints: a missing-cmi module type now hits `assert false`
again, while an abstract one still raises Cannot_scrape_package_type.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: typing-missing-cmi-3/user.ml fails (Assertion failed in typemod.ml).
