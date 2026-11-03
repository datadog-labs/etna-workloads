# Rationale

Hunk reversed: `src/cmd/compile/internal/types2/literals.go`, `compositeLit`, `default:` case of the type switch (fix hunk in literals.go).

The fix replaced `x.mode = invalid; return` with `typ = Typ[Invalid]; base = typ` so checking continues and the inner elements get a recorded type. In go1.27.3 the early return is spelled `x.invalidate(); return`, so I restored that. After the "missing type in composite literal" error, the literal is abandoned and its elements are never checked. An inner literal such as `{x}` in `T{{x}}` then gets no type recorded.

The go/types hunk is not applicable. go/types is not under src/cmd/compile, so I left it unchanged.

Failing oracle case: `TestIssue69092` in types2 fails with "no type found for {x}". The other 591 cases pass.
