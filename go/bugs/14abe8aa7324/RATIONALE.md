# Rationale

Fix (#53635): in stencil.go's generic switch handling, skip the "convert the tag to interface{}" step when the tag type is not comparable (`[]T`, `func() T`, `map[int]T`, compared against nil).

go1.27.3 has no stencil.go (unified IR only). The equivalent logic is in `noder/writer.go` `switchStmt`, which chooses the tag type used for tag/case comparisons.

Change: in `writer.switchStmt`, when the tag type is non-interface and derived (mentions a type parameter, the writer's analogue of `HasShape()`), set `tagType` to `any`. This is the pre-fix behaviour of "always convert a shaped tag to interface{}", with no comparability exemption (the check the fix added). The existing `!tagTypeIsChan` loop becomes the `else if`.

Oracle: `test/fixedbugs/issue53635.go` fails. `switch []T(nil) { case nil: }` now compares `any([]int(nil))` to `any(nil)` and panics with "comparing uncomparable type []int".
