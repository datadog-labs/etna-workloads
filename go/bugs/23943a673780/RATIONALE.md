# Rationale

The fix (#44415) made `wrapCall` (walk/stmt.go) pass the method-call receiver
through the go/defer wrapper, so that the same unsafe.Pointer->uintptr argument
handling (CL 253457) applies to method calls. `wrapCall` no longer exists in
go1.27.3: go/defer wrapping is `normalizeGoDeferCall` in typecheck/stmt.go, and
method calls are `OCALLFUNC` on an `OMETHEXPR` with the receiver as Args[0].

Change (typecheck/stmt.go, `normalizeGoDeferCall`): add `isMethodCall` (callee
is an `OMETHEXPR`) and skip the "save the unsafe.Pointer operand of a
uintptr(unsafe.Pointer) argument" case for such calls. This restores the
pre-fix state where the unsafe-uintptr argument handling in go/defer wrappers
covered only plain function calls, not method calls. The uintptr value is then
spilled instead of the pointer, so the pointee is no longer kept alive/escaped
for `//go:uintptrescapes` methods.

Oracle: test/fixedbugs/issue24491a.go fails with `panic: method call: p failed`
(the deferred `s.test(...)` case added by the fix).
