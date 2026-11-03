# Rationale

Fix hunk (walk/complit.go, fixedlit): in the OSLICELIT case, slicelit's init statements were collected in a
temporary `sinit` and, for static kind, run through `orderBlock` before being appended to `init`.

go1.27.3 no longer has `ctxt`/`inNonInitFunction`. The static pass of `fixedlit` skips nested slice literals,
and the dynamic pass calls `slicelit` directly into `init`. I restored the pre-fix shape in
`src/cmd/compile/internal/walk/complit.go`: a nested OSLICELIT is initialised during the `initKindStatic` pass
(the pre-fix non-init-function case) through a `sinit` list that is appended to `init` without `orderBlock`.
The dynamic-pass call is removed so the literal is initialised only once.

Oracle: `test/fixedbugs/issue52673.go` fails with
`internal compiler error: 'f': value .autotmp_17 (nil) incorrectly live at entry`, which is the liveness
confusion the fix guards against. `TestShouldTest` passes.

Caveat: this change is broader than the original bug, because the original `ctxt` distinction no longer
exists. It runs slice literals nested in large array/struct literals at static time for all callers.
