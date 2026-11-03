# Rationale

Fix hunk reversed: `types2/lookup.go`, the added `if T == nil { panic("LookupFieldOrMethod on nil type") }` at the top of `LookupFieldOrMethod`.

In go1.27.3 that check sits in the exported wrapper `LookupFieldOrMethod`, which delegates to `lookupFieldOrMethod`. I removed the check from the wrapper, so the function again accepts a nil `T` without the explicit, documented panic. This is the pre-fix behavior. The doc-comment hunk ("T must not be nil") is not behavioral, so I left it alone.

Only `types2` exists under `src/cmd/compile/`. The `go/types` copy is outside the allowed scope.

Failing oracle case: `TestLookupFieldOrMethodOnNil` (types2). It expects a recovered panic with the string "LookupFieldOrMethod on nil type". Without the check, the call no longer panics with that message, so the test fails. The other 591 cases pass.
