# Rationale

The fix widened the rule `(IMake _typ (StructMake val))` to `(IMake _typ (StructMake ___))`, so that
`imakeOfStructMake` also runs for a StructMake with more than one argument. I restored the one-argument
form. In go1.27.3 the rule exists in two places (the fix covered only generic), so I reverted both.

- `ssa/_gen/generic.rules` and `rewritegeneric.go` (`rewriteValuegeneric_OpIMake`): the same hunks as
  the fix, reversed. The match is `(StructMake val)` and the generated code checks `len(v_1.Args) != 1`.
- `ssa/_gen/dec.rules` and `rewritedec.go` (`rewriteValuedec_OpIMake`): this is a copy of the rule for
  expand_calls. It was widened to `___` later and also covers the case. It is the same defect, so I
  reverted it too. Reverting generic alone does not reproduce the bug.

## Oracle
`test/fixedbugs/issue74908.go` fails. The compiler reports
`internal compiler error: 'f': not lowered: v13, Empty STRUCT`. The test builds an `IMake` of a
two-field struct `{e struct{}; b *byte}`, and nothing unwraps its `StructMake`.
`TestShouldTest` passes, as expected.
