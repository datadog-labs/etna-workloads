# Rationale
Hunk: ocaml/otherlibs/dynlink/byte/dynlink.ml, `implementation_imports`: removed the List.filter that dropped packed compunits (names containing '.') from required imports. Reverses fix.diff hunk `@@ -39,7 +39,11 @@ module Bytecode = struct` (today's code uses Symtable.Compunit.is_packed instead of String.contains ... '.').
Result: dynlink reports "no implementation available for Packed.A" for packed modules.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: lib-dynlink-packed (loader.ml) fails.
