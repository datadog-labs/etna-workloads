# Rationale

## src/cmd/compile/internal/typecheck/expr.go (tcIndex)
Reverses the single implementation hunk of the fix: re-adds the constant
index bounds check (negative, array out-of-bounds, constant-string
out-of-bounds, too large) in `tcIndex` for TSTRING/TARRAY/TSLICE, plus the
`go/constant` and `go/token` imports it needs. The code is identical to the
removed block; go1.27.3 still has `ir.ConstOverflow`, `ir.IsConst`, etc.

## Oracle
`test/fixedbugs/issue65417.go` fails: in generic `f[T byte]`, `str[unsafe.Sizeof(t)]`
is a constant index (1) into a constant string "a" after instantiation, and
typecheck now reports a compile error "invalid string index uintptr(1) (out of
bounds for 1-byte string)" instead of compiling and panicking at run time.
