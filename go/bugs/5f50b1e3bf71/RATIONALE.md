# Rationale

All changes are in `src/cmd/compile/internal/noder/writer.go`, `switchStmt`.

- Removed `tagTypeIsChan` (declaration, assignment) and the `if !tagTypeIsChan { ... }` guard around the
  "convert everything to any" loop: reverses fix hunks 1, 2 and 3.
- In the case loop, `w.implicitConvExpr(tagType, cas)` is used unconditionally (the fix's `typ = nil` for channels
  is gone): reverses hunk 4.
- go1.27.3 also had a later refinement `&& (types2.IsInterface(casType) || types2.IsInterface(tagType))` on the
  AssignableTo check. It covers the channel case from another path (chan vs <-chan is not interface, so no
  conversion to any happens), so I removed it to restore the pre-fix condition.

Oracle: test/fixedbugs/issue67190.go fails with `panic: bad narrow case`. `ch1` (chan) vs `ch2` (<-chan) are not
assignable, so tag and cases are wrapped in `any`. Equality on interfaces holding different channel types is false,
so the switch takes `default`.
