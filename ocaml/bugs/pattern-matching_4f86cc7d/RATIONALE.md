# Rationale
File: ocaml/lambda/matching.ml, function `compute_arg_partial`.
Today's code only forces `global = Partial` for Mutable args when `tempo = Following`.
I changed it to always return `Arg partial`, ignoring mutability. This reverses the fix.diff hunk
`@@ -3661,6 +3669,142 @@ ... compute_arg_partial` (and the `arg_partial` use in `do_compile_matching`),
so type-checker totality is trusted even under mutable fields (the Pattern-Matching Bug totality aspect).
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: some match-side-effects tests fail (e.g. Match_failure expected, got unknown constructor).
