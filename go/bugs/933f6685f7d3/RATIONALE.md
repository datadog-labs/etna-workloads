# Rationale

Changed `src/cmd/compile/internal/types/fmt.go`, `fldconv`, fmtTypeID branch for embedded fields.

Fix hunk reversed: the fix added the `struct{ Name = Type }` syntax so LinkString distinguishes embedded
fields renamed via type aliases. In go1.27.3 this is the `if tsym != nil && (s == tsym || ...) { s = nil }`
check, which suppresses the field name only when it matches the embedded type's name. I made the
suppression unconditional (`s = nil`), so embedded fields always print without a name, as before the fix
(the `f.Embedded == 0` condition that omitted embedded names).

Oracle: `Test/fixedbugs/issue50190.go` fails. `struct{ int }` and `struct{ Int }` (with `type int float32`)
both get link string `struct { int }`, so the compiler reports "internal compiler error: collision: types
struct { int } and struct { int } have link string ...". `TestShouldTest` still passes.
