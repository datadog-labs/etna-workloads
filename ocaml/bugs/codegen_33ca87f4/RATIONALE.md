# Rationale
File: ocaml/asmcomp/cmm_helpers.ml (today's home of cmmgen's div_int/mod_int). Two hunks:
- `div_int`: re-added `| (Cconst_int (0, _) as c1, c2) -> Csequence(c2, c1)`; reverses fix hunk `@@ -338,8 +338,6 @@ let rec div_int c1 c2 is_safe dbg =`.
- `mod_int`: re-added `| (Cconst_int (0, _), c2) -> Csequence(c2, Cconst_int (0, dbg))`; reverses `@@ -386,8 +384,6 @@ let mod_int c1 c2 is_safe dbg =`.
Effect: `0 / f()` and `0 mod f()` with f()=0 no longer raise Division_by_zero.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`: tests/basic/zero_divided_by_n.ml fails (see output below).
> Running action 9/9 (compare-bytecode-programs)
> Comparing bytecode programs <local-path> and <local-path>
> Action 9/9 (compare-bytecode-programs) => passed
