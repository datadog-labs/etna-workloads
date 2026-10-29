# Rationale

Fix hunks reversed (trigger half of the fix only):

1. `src/attach.c` fixSelectCb: the fix set `pItem->fg.notCte = 1` when it stripped
   `zDatabase` from a FROM term in a trigger/view. I removed that assignment in
   today's code. Without it, `main.map` in a trigger, once the schema qualifier is
   stripped (fixedSchema=1), is eligible to match a CTE named `map`
   (resolveFromTermToCte's `fixedSchema==0 && zDatabase!=0` test no longer excludes it).
2. `src/select.c` resolveFromTermToCte: removed the later-added assertion
   `hadSchema==0 || notCte!=0`, which would otherwise fire because (1) makes it false
   (it encodes the invariant the fix introduced).

The UPDATE-FROM half (update.c, notCte on a[0]) is still covered by
`sqlite3SrcListLookup` in delete.c, so it was not reverted.

Oracle failure: `with1-27.1` — expected `1 cte1 main1 | 2 cte2 main2 |`, got
`1 cte1 cte1 | 2 cte2 cte2 |` (`main.map` in the trigger wrongly resolves to the CTE).
