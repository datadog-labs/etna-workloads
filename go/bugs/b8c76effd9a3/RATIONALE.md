# Rationale

Hunk changed: `src/cmd/compile/internal/types/type.go`, `NewPtr`.

The fix added `if elem.Noalg() { t.SetNoalg(true) }` so that a pointer to a noalg type is also noalg.
In go1.27.3 this logic has an extra line, `t.alg = ANOALG`, in the same block.
I removed the whole block (the `SetNoalg(true)` and the `alg = ANOALG` line). This restores the pre-fix behaviour: the pointer type is not marked noalg and keeps `alg = AMEM`.
Both lines were only ever reached under the `elem.Noalg()` condition that the fix introduced, so removing them is the same as reverting the fix.

## Oracle
`test/fixedbugs/issue65957.go` fails.
`*[4]int32`, the PtrToThis of a noalg type, ends up in typelinks.
The reflect-created `[4]int32` then resolves to the compiler's noalg array type, and using it as a map key panics with `hash of unhashable type [4]int32`.
