# Rationale

Fix hunk reversed: `src/cmd/compile/internal/types2/unify.go` in `nify`, the
case "x is a type parameter with an already-inferred type that unifies with y".
(The go/types hunk is outside src/cmd/compile and is not touched.)

go1.27.3 still contains the fix's code verbatim (the `switch { case xn / case yn / default }`
guarded by `mode&exact == 0`). I replaced it with the pre-fix logic: only
`if yn { u.set(px, y) }`. The directed-channel selection (`default` branch) is gone, so
the inferred type depends on argument order: once a bidirectional `chan T` is recorded
for the type parameter, a later `<-chan T` does not replace it.

Oracle failures: `TestFixedbugs/issue62157.go` (and parent `TestFixedbugs`).
`f(a, b)` with `a chan string`, `b <-chan string` infers `chan string`, so `b` is rejected
(spurious assignment error), while `f(b, a)` works. This is the order dependency in #62157.
