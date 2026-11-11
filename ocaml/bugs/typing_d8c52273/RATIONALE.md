# Rationale
typing/typecore.ml, `is_nonexpansive_struct_item`: removed the `Tstr_open {open_expr=m;_}` case (which checked `is_nonexpansive_mod m`) and put `Tstr_open _` back in the always-nonexpansive list. Reverses hunk `@@ -1873,10 +1873,11 @@ and is_nonexpansive_mod mexp =` of typing/typecore.ml.
Commands: `make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/generalized-open/expansiveness.ml fails (the `op` binding is generalized rather than weak).
