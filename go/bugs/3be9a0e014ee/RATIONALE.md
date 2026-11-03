# Rationale

Fix hunk reversed: `src/cmd/compile/internal/types2/call.go`, `Checker.selector` Error label, which added `x.typ = Typ[Invalid]`.
In go1.27.3 the line is `x.typ_ = Typ[Invalid]` (operand field renamed, `x.mode = invalid` became `x.invalidate()`). I removed it, so after a selector error the operand keeps its stale type instead of the invalid type.
The go/types hunk is not applicable: this task covers only src/cmd/compile.

Oracle failures: TestFixedbugs and TestFixedbugs/issue76103.go (types2). The expected "not enough arguments ... have (unknown type)" errors are no longer reported as expected.
