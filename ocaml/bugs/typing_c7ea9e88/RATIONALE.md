# Rationale

The fix (PR#7269) made variance computation reject `[< `Conj of 'a & sub | ...]` in a GADT
(the segfault came from matching a conjunctive-constraint variant covariantly).
In 5.5.2 that variance code (typing/typedecl_variance.ml) was already changed upstream so the
type is accepted ("ok"), and the segfault is prevented by the partial-match warning
(see the updated testsuite/tests/typing-gadts/pr7269.ml). So the fix's hunk
`@@ -687,7 +687,8 @@ let compute_variance env visited vari ty` (typedecl.ml, `if List.length tyl > 1 then upper else inter vari upper`)
cannot be reversed literally. I re-introduced the same bug (conjunctive tags unguarded -> segfault) differently:

- ocaml/typing/parmatch.ml, `full_match` (non-closing branch): a tag whose field is a conjunctive
  `Reither (_, _ :: _ :: _, _)` is now treated as covered, so the "this pattern-matching is not
  exhaustive ... `Conj _`" warning disappears and `f (T (`Other msg) : s t)` is run against `Conj `B`,
  segfaulting. This reverses the effect of the typing/typedecl.ml hunk (conjunctive Reither tags
  (tyl > 1) are specially handled), the only protection against PR#7269 today.

Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
pr7269.ml => failed (expect process segfaulted, signal 11).

RESULT: injected
