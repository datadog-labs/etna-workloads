# Rationale

Fix hunk reversed: esc.go `mustHeapAlloc` additions (OCLOSURE / OCALLPART size >= maxImplicitStackVarSize => heap).
In go1.27.3 this logic lives in `HeapAllocReason` (src/cmd/compile/internal/escape/utils.go), as the OCLOSURE and
OMETHVALUE (successor of OCALLPART) checks. I removed both, plus the now-unused `typecheck` import.
The closure.go hunk was a comment only; not touched.

Oracle: test/fixedbugs/issue39292.go fails: the compiler crashes (panic in walk) when the
method-value wrapper struct (t [10000]*int) is too large for the stack but isn't heap allocated.
