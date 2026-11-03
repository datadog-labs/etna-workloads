# Rationale

Fix: `any` must be treated as an alias like `byte`/`rune` (#49665). In go1.27.3 the
identity/cmp parts (identity.go, type.go) are already structured differently, so I
reverted the two places where `AnyType` was added to the byte/rune special case:

1. `reflectdata/reflect.go` `formalType`: reverses the hunk that added `types.AnyType`
   to the substitution list. `any` is no longer mapped to `types.Types[TINTER]`, so
   the reflect tables see a distinct `any` type.
2. `types/fmt.go` `tconv2`: reverses the hunk adding `t == AnyType` to the
   "collapse predeclared aliases in %-T mode" check, so `any` prints as `any`
   in type-ID mode instead of `interface {}`.

## Oracle
`test/fixedbugs/issue49665.go` fails: prints `*any` / `*interface {}` instead of
`*interface {}` twice.
