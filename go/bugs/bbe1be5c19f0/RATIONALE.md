# Rationale

All changes are in `tree/src/cmd/compile/internal/types/size.go`. The noder hunks (`base.Pos` in typeDecl/varDecl) have no counterpart: the -G=3 noder was removed and unified IR is the only front end. Those hunks are not reverted.

1. TCHANARGS case of CalcSize: removed the `CalcSize(t1.Elem())` call. This reverses the fix's added call, so the element size may not be computed when the width check runs.
2. Channel, array (now `CalcArraySize`) and "type too large" errors: `base.Errorf(...)` is changed back to `base.ErrorfAt(typePos(t), 0, ...)`. This reverses the fix's switch to `base.Errorf`, which uses `base.Pos`. In the unified IR, types built by the reader often have no position, so `typePos` hits `base.Fatalf("bad type")`.

## Failing oracle cases
- test/fixedbugs/issue49767.go: "internal compiler error: bad type: chan struct { v [65536]byte }" instead of "channel element type too large".
- test/fixedbugs/issue49814.go: "internal compiler error: bad type: [1125899906842624]byte" instead of "larger than address space".
