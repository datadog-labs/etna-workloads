# Rationale

Fix: in the noder, a blank-named interface method was reported ("methods must have a
unique non-blank name") and then dropped (`continue`), so no follow-up errors about
types not implementing it. The noder is gone in go1.27.3; the equivalent is
`types2/interface.go` `Checker.interfaceType`.

Change: removed the `continue // ignore` after the `BlankIfaceMethod` error, so the blank
method is again kept in the interface (pre-fix behaviour: error plus retained method).

Oracle: `test/interface/explicit.go` fails with unmatched errors at lines 105/106:
"*T2 does not implement B1 (missing method _)" — exactly the useless follow-up
errors the fix removed.
