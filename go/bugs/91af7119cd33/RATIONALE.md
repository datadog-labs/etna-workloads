# Rationale (issue 70417: methods on generic/instantiated alias types)

Changes in `tree/src/cmd/compile/internal/types2`:

1. `signature.go` `collectRecv`, `rtparams == nil` branch: removed the loop that follows the
   pointer/alias chain and reports "cannot define new methods on instantiated type" while
   invalidating recvType. Reverses the fix hunk adding that loop.
2. `signature.go` `collectRecv`, `*Alias` case in the `rtparams != nil` branch: instead of
   reporting "cannot define new methods on generic alias type" and leaving baseType nil,
   set `baseType = asNamed(t)` (the pre-fix behaviour), so the receiver is instantiated and
   constraints are collected for a generic alias.
3. `resolver.go` `resolveBaseTypeName`: removed the "an alias must not be generic" stop
   (the fix's `tdecl.TParamList != nil` check), so methods on generic aliases are collected again.

Note: current code already moved the old validRecv `hasTypeParams` check into collectRecv, so hunk 1 is its equivalent.

Failing oracle cases: TestFixedbugs/issue70417.go, TestFixedbugs/issue47968.go, TestSpec/receivers.go
(missing expected errors / unexpected errors for methods on instantiated or generic alias receivers).
