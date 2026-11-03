# Rationale

Fix hunk reversed: types2/expr.go `case *syntax.BasicLit` added `x.expr = e; check.overflow(x)` after the literal was converted (issue #54280).
In go1.27.3 that code lives in `check.basicLit` (src/cmd/compile/internal/types2/literals.go). I removed the
`x.expr = e` / `check.overflow(x, opPos(x.expr))` lines, so untyped integer literals wider than 512 bits are no longer rejected.
The message-format hunk (`constant %soverflow`) is left alone, since it only changes the text and not the behaviour.

Failing oracle cases: `test/fixedbugs/issue54280.go` (compilation succeeds unexpectedly instead of reporting "constant overflow")
and `test/const7.go` (x2: a 513-bit literal compiles unexpectedly).
