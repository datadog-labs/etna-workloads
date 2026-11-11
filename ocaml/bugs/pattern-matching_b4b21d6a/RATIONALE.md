# Rationale
Reverses fix.diff hunks in typing/parmatch.ml (the Tpat_var "*extension*" design of PR#7330), re-expressed in today's code:
- `@@ -781,10 +781,10 @@ let build_other` : build_other again emits a Tpat_construct with cstr_name "*extension*" and no args instead of a Tpat_var.
- `@@ -1743,7 +1745,7 @@ let contains_extension` : contains_extension again looks for a Tpat_construct named "*extension*".
The counter-example then fails to re-type for GADT-style extension constructors (IPair), so the non-exhaustive warning is lost.
Not reversed: the Tpat_var print/Conv/typecore hunks, which have no equivalent in today's code (the Conv module is gone).
Commands: `make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> typing-extensions/open_types.ml fails (also its expect variant).
