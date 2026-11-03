# Rationale

Fix: add `(Store {t} _ _ mem) && t.Size() == 0 => mem` to dec.rules, so zero-sized stores are removed.

Changes in tree/ (all under src/cmd/compile/internal/ssa):

1. `_gen/dec.rules` + generated `rewritedec.go`: removed the `(Store {t} _ _ mem) && t.Size() == 0 => mem` rule.
   This reverses the fix's dec.rules and rewritedec.go hunks exactly.
2. `_gen/generic.rules` + generated `rewritegeneric.go`: removed `(Store _ (Empty) mem) => mem`.
   Reverting hunk 1 alone does not bring the bug back, because go1.27.3 has this second rule
   that also deletes zero-sized stores (a Store of an `Empty` value, which expand_calls produces
   for a zero-sized StructSelect of an arg). It is the same defect: zero-sized stores survive to lowering.

Oracle: test/fixedbugs/issue63490.go (both cases) fails. Building the runtime with the modified compiler
dies with `internal compiler error: 'typesEqual': not lowered: v37, Empty STRUCT`, since a zero-sized
store keeps its `Empty` operand alive and it is never lowered. This is the same kind of failure the
fix guards against, but it is broad: the Go build itself breaks, so the test fails at build time
rather than only when compiling issue63490.go.
