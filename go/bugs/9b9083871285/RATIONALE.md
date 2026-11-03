# Rationale

Fix: receivers of instantiated methods were rebuilt with NewParam/NewVar, which drops
the parent scope (and other Var state); the fix clones the original Var (substVar).
In go1.27.3 the helper is `cloneVar` (types2/subst.go).

Changes (src/cmd/compile/internal/types2):
- named.go, `Named.expandMethod`: `newSig.recv = cloneVar(oldSig.recv, rtyp)` reverted to
  `NewParam(oldSig.recv.pos, oldSig.recv.pkg, oldSig.recv.name, rtyp)`
  (reverses the named.go `instantiateMethod` hunk).
- subst.go, `replaceRecvType`: `cloneVar(sig.recv, new)` reverted to
  `NewVar(sig.recv.pos, sig.recv.pkg, "", new)` (reverses the replaceRecvType hunk).
The `var_` hunk is a pure refactor and is left as is.

Oracle failures: TestInstantiatedObjects and TestInstantiatedObjects/recv
(the instantiated receiver's Parent() is nil instead of the method scope).
