# Rationale
Hunk: ocaml/typing/parmatch.ml, `build_other` (ext-constructor case). Reverses fix.diff hunk
`@@ -780,8 +780,7 @@ let build_other_constant ...` (build_other). The fix replaced reusing the
real constructor (printed under its own name) with a fake "*extension*" placeholder; today's code
uses a Tpat_var "*extension*". I reverted to building a Tpat_construct with the real constructor,
so the warning shows a matched constructor (e.g. `Foo`) as the counter-example, and the
"must include a wild card" note (detected through the `*extension*` var) disappears.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> open_types.ml failed;
final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh -> still failed.
