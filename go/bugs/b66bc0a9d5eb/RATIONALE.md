# Rationale

Fix: "make each method instantiation independently lazy" (#50619). The
behavioural part: when expanding a method for instantiated type t, if the
original method's receiver base is already t, return the original method, so
Method -> Receiver Type -> Method returns to the same *Func.

## Change
`src/cmd/compile/internal/types2/named.go`, `(*Named).expandMethod`: after
fetching `oldSig`, compute `rbase, _ := deref(oldSig.Recv().Type())` and
`return orig` if `rbase == t`. This is the `if rbase == t { return origm }`
hunk of the fix's `named.go` `expandMethod`. The methodList/lazy machinery
the fix added already exists in a different form in go1.27.3, so only this
early return was re-expressed. The comment in the current code ("One must not
return the origin method here") records the later reversal of that design.

## Oracle failures
`TestGenericMethodInfo` fails: inside `func (r N[B]) m() { r.m() }`, `r.m`
resolves to the declared method itself, but the test expects a distinct func.
Other cases fail because the checker crashes (panic in `Config.Check`, seen
via `TestMonoBad`), which aborts the test binary. The later cases (ExampleInfo,
TestObjectString, TestStdFixed, and others) are therefore reported as failing
too.
