# Rationale

Changed only `tree/src/cmd/compile/internal/ssagen/ssa.go`, function `(*state).ternary`.

Fix hunks reversed:
- Hunk 1 (new `ternaryVar` marker) and hunk 2 (variable-based then/else/end with `s.variable`): in go1.27.3 the marker is a local in `ternary`, so I removed it along with `bEnd`, the per-branch `s.vars[...]` assignments and the `s.variable` call.
- `ternary` is back to the pre-fix shape: the else block falls through to the then block, which begins with an explicit `OpPhi(x, y)`.

An explicit Phi is incompatible with the large-function phi placement (>500 blocks), which is the original bug (#60982).

## Oracle
`test/fixedbugs/issue60982.go` (both cases) fails. Compiling large functions that use min/max or `ternary` (here `reflect.StructOf`) panics in `nilcheckelim` with a nil pointer dereference. This is the same defect: phis already present when large-function phi placement runs.
