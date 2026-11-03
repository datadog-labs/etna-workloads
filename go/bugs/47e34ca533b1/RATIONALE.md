# Rationale

Fix: "ensure that named types never expand infinitely" — instances created during
expansion share the expanding type's Context, so instantiation cycles terminate.

Changed: `src/cmd/compile/internal/types2/named.go`, `newNamedInstance`: removed the block
that sets `inst.ctxt = expanding.inst.ctxt`. This reverses the fix's named.go hunk
(passing the expanding type's Context to newly created instances). In go1.27.3 it carries an
extra same-package condition, but it is the same mechanism. Without it, instances created during
expansion get their own fresh Context, so chains like T1[P]->T2[P]->T3[P]->T1[P] reached via
the API never find a previously seen instance and expand without end.

Oracle: `TestFiniteTypeExpansion` (types2) fails; 1 of 592 oracle cases fails.
