# Rationale

Fix (#56665): in `validType0`, when a cycle through an instance `t` is found,
the fix marks both `t` and `t.Origin()` invalid. Before the fix only `t` was
marked (`t.underlying = Typ[Invalid]`), so the generic origin stayed valid.

In go1.27.3 the origin is invalidated by `t.Origin().fromRHS = Typ[Invalid]`
in `src/cmd/compile/internal/types2/validtype.go`. I replaced that with the
pre-fix statement `t.underlying = Typ[Invalid]` (only the instance), so the
origin's RHS is no longer marked invalid. (The go/types copy is generated
from types2 and is outside the allowed scope.)

Expected oracle failures: types2 `TestCheck`/fixedbugs cases `issue56665.go`
and `issue49043.go` (missing "invalid recursive type" errors on the generic
declarations / extra cycles through origin). See check.sh output for results.
