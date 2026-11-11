# Rationale
File: ocaml/stdlib/camlinternalFormat.ml, in fmt_ebb_of_string: the Int32 ('l'), Nativeint ('n'), Int64 ('L') cases
now call `get_pad ()` instead of `get_int_pad ()`. This reverses the fix hunks
`@@ -2257,7 +2258,7 @@`, `@@ -2269,7 +2270,7 @@`, `@@ -2281,7 +2282,7 @@` (replacing get_pad by get_int_pad). The plain-int case is left alone.
Effect: "%047.27ld" etc. regress to the PR#6938 behaviour (strict rejection of 0-padding with precision instead of legacy handling).
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh; then final make clean && make -j8 && make -j8 ocamltest && run-oracle.sh: pr6938.ml fails.
