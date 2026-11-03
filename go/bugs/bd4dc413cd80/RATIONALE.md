# Rationale

The fix added `types.IsComparable(t)` to the direct-interface helpers in
`src/cmd/compile/internal/ssa/rewrite.go`. In go1.27.3 the helpers were
renamed to `isDirectAndComparableType1` and `isDirectAndComparableIface1`.
The rules in `_gen/*.rules` and the generated rewrite files are unchanged.

I made two changes, one per fix hunk:

- `isDirectAndComparableType1`: the `OpAddr` case returns
  `types.IsDirectIface(t)` only. This reverses the fix's `isDirectType1` hunk.
- `isDirectAndComparableIface1`: the `OpAddr` case returns
  `types.IsDirectIface(t)` only. This reverses the fix's `isDirectIface1` hunk.

The function names and doc comments still say "comparable". I left them alone
so the diff contains only the removed checks.

With the checks gone, interface comparisons on func, map and slice types are
treated as direct pointer comparisons. These types are pointer-shaped but not
comparable, so the comparison no longer panics at run time.

## Oracle

`test/fixedbugs/issue76008.go` fails. The output is
`did not panic at line 13` and `did not panic at line 16`. These are the
`any(func(){}) == any(func(){})` and `any(map[int]int{}) == any(map[int]int{})`
cases. The slice case still panics.
