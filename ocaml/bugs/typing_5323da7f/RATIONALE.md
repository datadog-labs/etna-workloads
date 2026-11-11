# Rationale

The fix ("fix warnings", record-disambiguation branch) reworked `disambiguate_lid_a_list`
so that when the candidate filter (`disambiguate_label_by_ids`) fails, the label is
taken as `fst (List.hd labels) (* will fail later *)` and no disambiguation warnings
are issued ("fail but don't warn" in the new tests). In today's code that is the
`Error((lbl,_use) :: _rest) -> lbl (* will fail later *)` arm of `Label.disambiguate`.

## Hunk (one)
File `typing/typecore.ml`, `NameChoice.disambiguate`, `expected_type = None` case.
The `Error` arm now behaves like the `Ok` arm (calls `use ()`, `warn_if_ambiguous`) and
additionally issues the non-principal warning, so a failing record expression/pattern
warns before the error. Reverses the fix hunk
`@@ -637,54 +637,56 @@ let disambiguate_label_by_ids ...` (`if ok then Label.disambiguate ... else fst (List.hd labels) (* will fail later *)`)
and the test addition "let b : bar = {x=3; y=4};; (* fail but don't warn *)".

## Build/test
`make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
`records.ml => failed` (extra "Warning 18 [not-principal]" in `{x=3; contents=2}` expectation).

RESULT: injected
