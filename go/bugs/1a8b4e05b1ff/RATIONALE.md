# Rationale

Changed: `src/cmd/compile/internal/types/fmt.go`, `fldconv`. go1.27.3 still has the fix's code verbatim, so I reversed it by hand.

- Removed the `nameSep` variable (`" = "` for fmtTypeID) and went back to writing `" "`. This reverses the hunk that added `nameSep` and the `b.WriteString(nameSep)` change.
- Removed the `if f.Embedded != 0 { ... }` block. That block computed `tsym` and kept the field name for renamed embedded fields in LinkString. I restored the original condition `if s != nil && f.Embedded == 0`, so embedded fields never print a name.
- As a result, `struct{ int }` and `struct{ Int }` (with `type Int = int`) get the same link string, `struct { int }`.

## Oracle
`test/fixedbugs/issue50190.go` fails. The compiler reports `internal compiler error: collision: types struct { int } and struct { int } have link string "struct { int }"`. `TestShouldTest` still passes.
