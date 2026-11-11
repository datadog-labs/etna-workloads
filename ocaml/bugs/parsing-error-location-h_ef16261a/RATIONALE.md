# Rationale
One hunk, parsing/location.ml (`highlight_quote`, single-line case): removed the branch that emits a tab
where the source line has a tab, so alignment pads with spaces only. Reverses fix.diff hunk
`@@ -464,14 +464,20 @@ let highlight_quote ppf` (today's code uses a `for i` loop; the tab branch
`if line.[i] = '\t' ...` became plain `else Fmt.pp_print_char ppf ' '`).
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tests/messages/highlight_tabs.ml fails.
