# Rationale

Fix: bloop (`b.Loop()` keep-alive pass) must only keep alive *addressable* nodes.

Changes, all in `src/cmd/compile/internal/bloop/bloop.go`:

1. `getAddressableNameFromNode` (fix added it, replacing `getNameFromNode` at the
   call sites; in 1.27.3 the callers are `getKeepAliveNodes` and `preserveCallArgs`).
   It now returns `getNameFromNode(n)` without the `ir.IsAddressable` check, which
   is the pre-fix behaviour (callers used getNameFromNode directly).
2. `keepAliveAt`: removed the `FatalfAt` "node is not addressable" assertion the fix added.

Result: a non-addressable name (e.g. a function name passed as an argument,
`receiver(argument)` in test/bloop.go) is wrapped in `runtime.KeepAlive(unsafe.Pointer(&name))`,
taking the address of a non-addressable node, and the compiler crashes in ssagen.

Failing oracle cases: `Test` and `Test/bloop.go` (compiler panic compiling test/bloop.go).
