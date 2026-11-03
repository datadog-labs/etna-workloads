# Rationale

Fix (issue 23017) removed the OAS2 handling from `order.mapAssign`, relying on
`ascompatee` for correct ordering. In go1.27.3 `src/cmd/compile/internal/walk/order.go`:

1. `mapAssign`: re-added the `case ir.OAS2` branch (the removed hunk). For each
   `m[k]` on the LHS it copies `m` and `k` to temps, assigns the value to a temp
   in the multi-assignment, and emits `m[k] = tmp` after the statement. (The
   OAS2DOTTYPE/OAS2MAPR/OAS2FUNC and instrumenting parts are omitted: those
   paths in go1.27.3 already use as2func/as2ok temporaries and never call mapAssign.)
2. `stmt` `case ir.OAS2`: calls `o.mapAssign(n)` instead of `o.out = append(o.out, n)`, as before the fix.

## Oracle failure
`test/fixedbugs/issue23017.go` fails: `m[2], *p = 42, 2` with nil p now performs the
map store after the panicking `*p` store, so `len(m)` is 0 instead of 1
("wanted 1, but got 0").
