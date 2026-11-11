# Rationale
File: ocaml/typing/includecore.ml (`type_declarations`'s variance-coherence check near the end, today's code replacing the old `if decl2.type_private = Private || ...` block).
Reverses fix.diff hunk `@@ -244,13 +244,8 @@ let type_declarations ?(equality = false) env name decl1 id decl2 =`:
the fix made the variance check also apply to private abbreviations (PR#5993). I added a `private_abbrev` condition (private, abstract kind, with manifest) that skips the variance check when the type isn't exported abstract, so `sig type -'a t = private int end` accepts `type +'a t = private int`.
Tests/Changes hunks of fix.diff not touched (test/Changes only).
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: typing-modules/Test.ml => failed (reference mismatch, expected variance error missing).
