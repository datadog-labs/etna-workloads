# Rationale
Fix: #12145 (fix.diff), removed the `update_type` call in `Typedecl.transl_type_decl`
(hunk `@@ -1113,15 +1103,6 @@ let transl_type_decl env rec_flag sdecl_list =`, "Update stubs" block).
In 5.5.2 the call had been re-added after the regularity/well-foundedness checks
(`ocaml/typing/typedecl.ml`). The single hunk I changed moves that
"Update temporary definitions" block back to right after the final env is built and
before the "Check for ill-formed abbrevs" checks, i.e. where the fix's removed block
ran (before `check_abbrev_regularity`). This reintroduces the loop: unifying the cyclic
abbreviation before it is rejected makes ocamlc loop on the `type cycle = cycle id ... and s = cycle t`
case from the new test in tests/typing-misc/constraints.ml.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
constraints.ml hangs (no "passed"; killed by timeout). Direct check:
`ocamlc.opt -nostdlib -I stdlib -i a.ml` with the cycle example times out (exit 124).
