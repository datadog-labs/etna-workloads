# Rationale

## src/backend/optimizer/prep/prepunion.c, generate_union_paths()
Traces to the fix.patch prepunion.c `make_union_unique` hunk that made the Sort
conditional (`if (groupList) create_sort_path(...)`). In current code that logic
lives in the "Try Sort -> Unique on the Append path" block. I removed the
`if (groupList != NIL)` guard, so a Sort over zero columns is built again for
UNION over no columns, bringing back the bug.

The other hunks of fix_impl.patch have no reversible counterpart. The `Assert(numCols > 0)`
in make_setop is already gone, and the "punt if nothing to group on" early returns no longer exist.

## Failing oracle cases
- src/test/regress||union
