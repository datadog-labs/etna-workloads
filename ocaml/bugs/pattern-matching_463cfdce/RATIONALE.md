# Rationale
Fix PR#6466 added a special message for open-type (`*extension*`) counter-examples in the partial-match warning.
Hunk in ocaml/typing/parmatch.ml (`@@ do_check_partial ...` in fix.diff, "match v.pat_desc with Tpat_construct (_, {cstr_name="*extension*"}, _) -> ... wild card"): in today's code this is the `if contains_extension v then ... "Matching over values of extensible variant types ... must include a wild card pattern"` block, plus its helper `contains_extension`. I removed both, so the explanatory message is no longer emitted.
Other hunks of fix.diff (translcore.ml `as fn`, Changes, test reference) are not behavioural/not reverted.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: open_types.ml fails (expected output has the message).
