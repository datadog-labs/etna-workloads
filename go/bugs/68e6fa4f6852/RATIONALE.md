# Rationale

The fix (#43444) made init order be computed *before* dead-code removal, so
references inside dead code (`if false { _ = z }`) still count as init
dependencies. In go1.27.3 the init-order pass is types2's `initOrder`
(the old `pkginit.initOrder`/`deadcode.Func` split and `OAS` with nil RHS no longer
exist), and the dependency edges are recorded while type-checking.

Change (one hunk, src/cmd/compile/internal/types2/stmt.go, `*syntax.IfStmt`):
when the condition is a constant `false`, `check.decl` is cleared while checking
the `Then` branch, so uses there are not recorded as dependencies. This
reproduces the pre-fix effect: dead code stripped before init ordering hides its
dependencies. It reverses the fix's "build init task before deadcode" hunk
(main.go/init.go); the noder/staticinit hunks have no counterpart left.

Oracle: test/fixedbugs/issue43444.go fails, printing `d e a b c` instead of
`e a b c d` (d no longer waits for z).
