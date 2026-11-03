# Rationale

## Change
`tree/src/cmd/compile/internal/walk/walk.go`, `mayCall`: removed `ir.ODYNAMICDOTTYPE`
from the case list of ops that might panic (`OINDEX, ..., ODOTTYPE, ODIV, OMOD, ...`).

This reverses the single implementation hunk of the fix, which added `ir.ODYNAMICDOTTYPE`
to that list. The code in go1.27.3 is the same list (only reformatted, with `OSLICE2ARR`
added), so removing the entry restores the pre-fix behaviour exactly.

## Oracle failure
`test/typeparam/issue47924.go` fails: compiling `f(x.(K))` with a shape-typed `K` hits
`internal compiler error: mayCall` on the `DYNAMICDOTTYPE` node, because `mayCall` no
longer recognises it and falls to the default panic for unknown ops.
(`TestShouldTest` passes; it is not a compile test.)
